---
title:
  page: "NemoClaw CLI 命令參考"
  nav: "命令"
description: "插件及獨立 NemoClaw 命令的完整 CLI 參考。"
keywords: ["nemoclaw cli commands", "nemoclaw command reference", "NemoClaw CLI 命令", "NemoClaw 命令參考"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "nemoclaw", "cli"]
content:
  type: reference
  difficulty: technical_beginner
  audience: ["developer", "engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 命令

NemoClaw 提供兩個命令介面。
插件命令在 OpenClaw CLI 內的 `openclaw nemoclaw` 命名空間下運行。
獨立的 `nemoclaw` 二進位檔案處理主機端的設置、部署和服務管理。
當您運行 `npm install -g nemoclaw` 時，兩個介面都會被安裝。

## 插件命令

### `openclaw nemoclaw launch`

在 OpenShell 沙盒中啟動 OpenClaw。
如果 NemoClaw 檢測到已存在的主機安裝，除非傳入 `--force`，否則 `launch` 將停止。

```console
$ openclaw nemoclaw launch [--force] [--profile <profile>]
```

`--force`
: 跳過人體工學警告並強制由插件驅動引導。若無此旗標，NemoClaw 建議對於新安裝直接使用 `openshell sandbox create`。

`--profile <profile>`
: 要使用的藍圖設定檔。預設值：`default`。

### `nemoclaw <name> connect`

在 OpenClaw 沙盒內開啟交互式 shell。
在啟動後使用此命令，透過 TUI 或 CLI 與代理進行連接和聊天。

```console
$ nemoclaw my-assistant connect
```

### `openclaw nemoclaw status`

顯示沙盒健康狀況、藍圖運行狀態和推論配置。

```console
$ openclaw nemoclaw status [--json]
```

`--json`
: 以 JSON 格式輸出，供程式化使用。

### `openclaw nemoclaw logs`

串流藍圖執行和沙盒日誌。

```console
$ openclaw nemoclaw logs [-f] [-n <count>] [--run-id <id>]
```

`-f, --follow`
: 跟隨日誌輸出，類似於 `tail -f`。

`-n, --lines <count>`
: 顯示的行數。預設值：`50`。

`--run-id <id>`
: 顯示特定藍圖運行的日誌，而非最新的日誌。

### `/nemoclaw` 斜線命令

`/nemoclaw` 斜線命令可在 OpenClaw 聊天介面中使用，用於快速操作：

| 子命令 | 描述 |
|---|---|
| `/nemoclaw status` | 顯示沙盒與推論狀態 |

## 獨立主機命令

`nemoclaw` 二進位檔案處理在 OpenClaw 插件上下文之外運行的主機端操作。

### `nemoclaw onboard`

運行交互式設置精靈。
該精靈會創建 OpenShell 閘道器、註冊推論提供者、構建沙盒映像並創建沙盒。
將此命令用於新安裝，以及在更改策略或配置後重新創建沙盒。

```console
$ nemoclaw onboard
```

首次運行會提示輸入您的 NVIDIA API 金鑰，並將其保存到 `~/.nemoclaw/credentials.json`。

### `nemoclaw list`

列出所有註冊的沙盒及其模型、提供者和策略預設。

```console
$ nemoclaw list
```

### `nemoclaw deploy`

透過 [Brev](https://brev.nvidia.com) 將 NemoClaw 部署到遠端 GPU 執行個體。
部署腳本會在虛擬機上安裝 Docker、NVIDIA Container Toolkit (若有 GPU) 以及 OpenShell，然後運行 NemoClaw 設置並連接到沙盒。

```console
$ nemoclaw deploy <instance-name>
```

### `nemoclaw <name> connect`

按名稱連接到沙盒。

```console
$ nemoclaw my-assistant connect
```

### `nemoclaw <name> status`

顯示沙盒狀態、健康狀況和推論配置。

```console
$ nemoclaw my-assistant status
```

### `nemoclaw <name> logs`

查看沙盒日誌。
使用 `--follow` 實時串流輸出。

```console
$ nemoclaw my-assistant logs [--follow]
```

### `nemoclaw <name> destroy`

停止 NIM 容器並刪除沙盒。
這會從註冊表中移除沙盒。

```console
$ nemoclaw my-assistant destroy
```

### `nemoclaw <name> policy-add`

向沙盒添加策略預設。
預設會使用額外的端點擴展基準網路策略。

```console
$ nemoclaw my-assistant policy-add
```

### `nemoclaw <name> policy-list`

列出可用的策略預設，並顯示哪些已應用於沙盒。

```console
$ nemoclaw my-assistant policy-list
```

### `openshell term`

開啟 OpenShell TUI 以監控沙盒活動並批准網路流出請求。
在沙盒運行的主機上執行此命令。

```console
$ openshell term
```

對於遠端 Brev 執行個體，請 SSH 到該執行個體並在該處運行 `openshell term`，或使用端口轉發到閘道器。

### `nemoclaw start`

啟動輔助服務，例如 Telegram 橋接器和 cloudflared 隧道。

```console
$ nemoclaw start
```

Telegram 橋接器需要 `TELEGRAM_BOT_TOKEN`。

### `nemoclaw stop`

停止所有輔助服務。

```console
$ nemoclaw stop
```

### `nemoclaw status`

顯示沙盒列表和輔助服務的狀態。

```console
$ nemoclaw status
```

### `nemoclaw setup-spark`

在 DGX Spark 上設置 NemoClaw。
此命令應用 Ubuntu 24.04 所需的 cgroup v2 和 Docker 修復。
在 Spark 主機上以 `sudo` 運行。
