---
title:
  page: "使用 Brev 將 NemoClaw 部署到遠端 GPU 實例"
  nav: "部署到遠端 GPU"
description: "使用 Brev 部署為 NemoClaw 配置遠端 GPU 虛擬機。"
keywords: ["deploy nemoclaw remote gpu", "nemoclaw brev cloud deployment"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "deployment", "gpu", "nemoclaw"]
content:
  type: how_to
  difficulty: intermediate
  audience: ["developer", "engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 將 NemoClaw 部署到遠端 GPU 實例

透過 [Brev](https://brev.nvidia.com) 在遠端 GPU 實例上運行 NemoClaw。
`deploy` 命令會配置虛擬機、安裝依賴項，並將您連接到正在運行的沙盒。

## 先決條件

- 已安裝並經過身份驗證的 [Brev CLI](https://brev.nvidia.com)。
- 來自 [build.nvidia.com](https://build.nvidia.com) 的 NVIDIA API 金鑰。
- 已在本地安裝 NemoClaw。使用 `npm install -g nemoclaw` 安裝。

## 部署實例

創建一個 Brev 實例並運行 NemoClaw 設置：

```console
$ nemoclaw deploy <實例名稱>
```

將 `<實例名稱>` 替換為您遠端實例的名稱，例如 `my-gpu-box`。

部署腳本在虛擬機上執行以下步驟：

1. 如果存在 GPU，則安裝 Docker 和 NVIDIA Container Toolkit。
2. 安裝 OpenShell CLI。
3. 運行 nemoclaw 設置以創建網關、註冊提供者並啟動沙盒。
4. 啟動輔助服務，例如 Telegram 橋接器和 cloudflared 隧道。

## 連接到遠端沙盒

部署完成後，`deploy` 命令會在遠端沙盒內開啟一個互動式 shell。
要在關閉會話後重新連接，請再次運行 `deploy` 命令：

```console
$ nemoclaw deploy <實例名稱>
```

## 監控遠端沙盒

透過 SSH 連接到實例並運行 OpenShell TUI 以監控活動並批准網絡請求：

```console
$ ssh <實例名稱> 'cd /home/ubuntu/nemoclaw && set -a && . .env && set +a && openshell term'
```

## 驗證推理

在遠端沙盒內運行測試代理提示：

```console
$ openclaw agent --agent main --local -m "Hello from the remote sandbox" --session-id test
```

## GPU 配置

部署腳本使用 `NEMOCLAW_GPU` 環境變量來選擇 GPU 類型。
預設值為 `a2-highgpu-1g:nvidia-tesla-a100:1`。
在運行 `nemoclaw deploy` 之前設置此變量以使用不同的 GPU 配置：

```console
$ export NEMOCLAW_GPU="a2-highgpu-1g:nvidia-tesla-a100:2"
$ nemoclaw deploy <實例名稱>
```

## 相關主題

- [設置 Telegram 橋接器](set-up-telegram-bridge_zh_TW.md) 以透過 Telegram 與遠端代理進行交互。
- [監控沙盒活動](../monitoring/monitor-sandbox-activity_zh_TW.md) 以獲取沙盒監控工具。
- [命令](../reference/commands_zh_TW.md) 以獲取完整的 `deploy` 命令參考。
