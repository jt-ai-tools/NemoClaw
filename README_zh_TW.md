# NVIDIA NemoClaw: NVIDIA OpenShell 的 OpenClaw 插件

[English](./README.md) | [繁體中文](./README_zh_TW.md)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue)](LICENSE)
[![Security Policy](https://img.shields.io/badge/Security-Report%20a%20Vulnerability-red)](SECURITY_zh_TW.md)
[![Project Status](https://img.shields.io/badge/status-alpha-orange)](docs/about/release-notes_zh_TW.md)

NVIDIA NemoClaw 是一個開源技術棧，簡化了運行 [OpenClaw](https://openclaw.ai) 常駐助手的安全性。它安裝了 [NVIDIA OpenShell](https://github.com/NVIDIA/OpenShell) 運行時（[NVIDIA Agent Toolkit](https://docs.nvidia.com/nemo/agent-toolkit/latest) 的一部分），這是一個用於運行自主代理的安全環境，以及像 [NVIDIA Nemotron](https://build.nvidia.com) 這樣的開源模型。

> **Alpha 軟體**
> 
> NemoClaw 處於早期階段。請預期會有不完善之處。我們正在努力實現生產級的沙盒編排，但目前的起點是讓您建立自己的環境。
> 隨著我們對設計的迭代，界面、API 和行為可能會在不另行通知的情況下發生變化。
> 分享此專案是為了收集回饋並實現早期實驗，但不應將其視為生產就緒。
> 在專案演進過程中，我們歡迎來自社群的問題和討論。

---

## 快速入門

<!-- start-quickstart-guide -->

按照以下步驟開始使用 NemoClaw 和您的第一個沙盒化 OpenClaw 代理。

:::{note}
NemoClaw 目前需要全新安裝 OpenClaw。
:::

### 先決條件

在開始之前檢查先決條件，以確保您擁有運行 NemoClaw 所需的軟體和硬體。

#### 軟體

- Linux Ubuntu 22.04 LTS 版本及更高版本
- 已安裝並運行 Docker
- 已安裝 [NVIDIA OpenShell](https://github.com/NVIDIA/OpenShell)

### 安裝 NemoClaw 並引導 OpenClaw 代理

下載並運行安裝腳本。
該腳本在 Node.js 不存在時會先安裝它，然後運行引導式引導精靈來創建沙盒、配置推理並應用安全策略。

```console
$ git clone https://github.com/NVIDIA/NemoClaw.git
$ cd NemoClaw
$ ./install.sh
```

安裝完成後，摘要會確認運行環境：

```
──────────────────────────────────────────────────
Sandbox      my-assistant (Landlock + seccomp + netns)
Model        nvidia/nemotron-3-super-120b-a12b (NVIDIA Cloud API)
──────────────────────────────────────────────────
Run:         nemoclaw my-assistant connect
Status:      nemoclaw my-assistant status
Logs:        nemoclaw my-assistant logs --follow
──────────────────────────────────────────────────

[INFO]  === Installation complete ===
```

### 與代理對話

連接到沙盒，然後通過 TUI 或 CLI 與代理對話。

```console
$ nemoclaw my-assistant connect
```

#### OpenClaw TUI

OpenClaw TUI 開啟一個互動式對話界面。輸入消息並按 Enter 發送給代理：

```console
sandbox@my-assistant:~$ openclaw tui
```

向代理發送一條測試消息並驗證您是否收到回應。

#### OpenClaw CLI

使用 OpenClaw CLI 發送單條消息並列印回應：

```console
sandbox@my-assistant:~$ openclaw agent --agent main --local -m "hello" --session-id test
```

<!-- end-quickstart-guide -->

---

## 工作原理

NemoClaw 安裝 NVIDIA OpenShell 運行時和 Nemotron 模型，然後使用版本化的藍圖創建沙盒環境，其中每個網絡請求、文件訪問和推理調用都受聲明式策略管轄。`nemoclaw` CLI 編排整個堆棧：OpenShell 網關、沙盒、推理提供者和網絡策略。

| 組件             | 角色                                                                                      |
|------------------|-------------------------------------------------------------------------------------------|
| **插件 (Plugin)** | 用於啟動、連接、狀態和日誌的 TypeScript CLI 命令。                                          |
| **藍圖 (Blueprint)** | 版本化的 Python 產物，編排沙盒創建、策略和推理設置。                                          |
| **沙盒 (Sandbox)** | 運行 OpenClaw 的隔離 OpenShell 容器，具有策略強制執行的出口和文件系統。                       |
| **推理 (Inference)** | NVIDIA 路由的模型調用（雲端、本地 NIM 或 vLLM），對代理透明。                                |

藍圖生命週期遵循四個階段：解析產物、驗證其摘要、規劃資源並通過 OpenShell CLI 應用。

當出現問題時，錯誤可能源自 NemoClaw 或底層的 OpenShell 層。運行 `nemoclaw <name> status` 查看 NemoClaw 層級的健康狀況，運行 `openshell sandbox list` 檢查底層沙盒狀態。

## 推理配置文件 (Inference Profiles)

來自代理的推理請求永遠不會直接離開沙盒。OpenShell 攔截每次調用並將其路由到配置的提供者。NemoClaw 附帶三個配置文件：

| 配置文件    | 提供者        | 模型                                 | 使用場景                                       |
|-------------|--------------|--------------------------------------|-------------------------------------------------|
| `default`   | NVIDIA cloud | `nvidia/nemotron-3-super-120b-a12b` | 生產環境。需要 NVIDIA API 金鑰。               |
| `nim-local` | Local NIM    | `nvidia/nemotron-3-super-120b-a12b` | 私有雲。NIM 作為本地容器部署。                   |
| `vllm`      | vLLM         | `nvidia/nemotron-3-nano-30b-a3b`    | 本地開發。主機上的 vLLM。                       |

在啟動時使用 `--profile` 選擇配置文件，或在運行時切換而無需重啟沙盒：

```console
$ openclaw nemoclaw launch --profile vllm
$ openshell inference set --provider vllm-local --model nvidia/nemotron-3-nano-30b-a3b
```

## 防護層

沙盒啟動時具有嚴格的基線策略，控制網絡出口和文件系統訪問：

| 層級       | 保護內容                                            | 何時應用                   |
|------------|-----------------------------------------------------|----------------------------|
| 網絡       | 攔截未經授權的出站連接。                             | 運行時可熱重載。           |
| 文件系統   | 防止在 `/sandbox` 和 `/tmp` 之外讀取/寫入。           | 沙盒創建時鎖定。           |
| 進程       | 攔截特權提升和危險的系統調用。                       | 沙盒創建時鎖定。           |
| 推理       | 將模型 API 調用重定向到受控的後端。                  | 運行時可熱重載。           |

當代理嘗試訪問未列出的主機時，OpenShell 會攔截請求並在 TUI 中顯示以供操作員批准。

## 關鍵命令

### 主機命令 (`nemoclaw`)

在主機上運行這些命令以設置、連接和管理沙盒。

| 命令                                 | 描述                                                   |
|--------------------------------------|--------------------------------------------------------|
| `nemoclaw onboard`                  | 互動式設置精靈：網關、提供者、沙盒。                   |
| `nemoclaw deploy <instance>`         | 通過 Brev 部署到遠程 GPU 實例。                        |
| `nemoclaw <name> connect`            | 在沙盒內開啟互動式 shell。                             |
| `openshell term`                     | 啟動 OpenShell TUI 以進行監控和批准。                   |
| `nemoclaw start` / `stop` / `status` | 管理輔助服務（Telegram 橋接器、隧道）。                 |

### 插件命令 (`openclaw nemoclaw`)

在 OpenClaw CLI 內運行。這些命令正在積極開發中，可能並非全部功能齊全。

| 命令                                       | 描述                                              |
|--------------------------------------------|---------------------------------------------------|
| `openclaw nemoclaw launch [--profile ...]` | 在 OpenShell 沙盒內引導 OpenClaw。                |
| `openclaw nemoclaw status`                 | 顯示沙盒健康狀況、藍圖狀態和推理。                |
| `openclaw nemoclaw logs [-f]`              | 串流藍圖執行和沙盒日誌。                          |

查看完整的 [CLI 參考](https://docs.nvidia.com/nemoclaw/latest/reference/commands_zh_TW.md) 以了解所有命令、標記和選項。

> **已知限制：**
> - `openclaw nemoclaw` 插件命令正在積極開發中。請將 `nemoclaw` 主機 CLI 作為主要界面。
> - 在某些平台上，設置可能需要手動解決方法。如果遇到阻礙，請提交 Issue。


## 了解更多

參考文檔以獲取有關 NemoClaw 的更多信息。

- [概覽](https://docs.nvidia.com/nemoclaw/latest/about/overview_zh_TW.html)：NemoClaw 的作用以及它如何組合在一起
- [工作原理](https://docs.nvidia.com/nemoclaw/latest/about/how-it-works_zh_TW.html)：插件、藍圖和沙盒生命週期
- [架構](https://docs.nvidia.com/nemoclaw/latest/reference/architecture_zh_TW.html)：插件結構、藍圖生命週期和沙盒環境
- [推理配置文件](https://docs.nvidia.com/nemoclaw/latest/reference/inference-profiles_zh_TW.html)：NVIDIA cloud, NIM, 和 vLLM 配置
- [網絡策略](https://docs.nvidia.com/nemoclaw/latest/reference/network-policies_zh_TW.html)：出口控制和策略自定義
- [CLI 命令](https://docs.nvidia.com/nemoclaw/latest/reference/commands_zh_TW.html)：完整的命令參考

## 授權協議

本專案採用 [Apache License 2.0](LICENSE) 授權。
