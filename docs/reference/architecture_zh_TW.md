---
title:
  page: "NemoClaw 架構 — 插件、藍圖與沙盒結構"
  nav: "架構"
description: "插件結構、藍圖生命週期、沙盒環境以及推論路由。"
keywords: ["nemoclaw architecture", "nemoclaw plugin blueprint structure", "NemoClaw 架構", "NemoClaw 插件藍圖結構"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "sandboxing", "blueprints", "inference_routing"]
content:
  type: reference
  difficulty: intermediate
  audience: ["developer", "engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 架構

NemoClaw 由兩個主要組件組成：一個與 OpenClaw CLI 整合的 TypeScript 插件，以及一個編排 OpenShell 資源的 Python 藍圖。

## NemoClaw 插件

該插件是一個輕量級的 TypeScript 套件，在 `openclaw nemoclaw` 下註冊命令。
它與 OpenClaw 閘道器 (gateway) 在同一個程序中運行，並處理面向用戶的 CLI 交互。

```text
nemoclaw/
├── src/
│   ├── index.ts                    插件入口 — 註冊所有命令
│   ├── cli.ts                      Commander.js 子命令接線
│   ├── commands/
│   │   ├── launch.ts               全新安裝至 OpenShell
│   │   ├── connect.ts              進入沙盒的交互式 shell
│   │   ├── status.ts               藍圖運行狀態 + 沙盒健康狀況
│   │   ├── logs.ts                 串流藍圖與沙盒日誌
│   │   └── slash.ts                /nemoclaw 聊天命令處理程序
│   └── blueprint/
│       ├── resolve.ts              版本解析、快取管理
│       ├── fetch.ts                從 OCI 登錄檔下載藍圖
│       ├── verify.ts               摘要驗證、兼容性檢查
│       ├── exec.ts                 藍圖執行器的子程序執行
│       └── state.ts                持久化狀態 (運行 ID)
├── openclaw.plugin.json            插件清單 (manifest)
└── package.json                    在 openclaw.extensions 下聲明的命令
```

## NemoClaw 藍圖

藍圖是一個帶有版本控制的 Python 產出物，擁有自己的發布流。
插件會解析、驗證並以子程序方式執行藍圖。
藍圖驅動與 OpenShell CLI 的所有交互。

```text
nemoclaw-blueprint/
├── blueprint.yaml                  清單 — 版本、設定檔、兼容性
├── orchestrator/
│   └── runner.py                   CLI 執行器 — 規劃 / 應用 / 狀態
├── policies/
│   └── openclaw-sandbox.yaml       嚴格的基準網路 + 檔案系統策略
```

### 藍圖生命週期

```{mermaid}
flowchart LR
    A[解析] --> B[驗證摘要]
    B --> C[規劃]
    C --> D[應用]
    D --> E[狀態]
```

1. **解析 (Resolve)**：插件定位藍圖產出物，並根據 `blueprint.yaml` 中的 `min_openshell_version` 和 `min_openclaw_version` 約束檢查版本。
2. **驗證 (Verify)**：插件檢查產出物摘要是否與預期值符合。
3. **規劃 (Plan)**：執行器確定要創建或更新哪些 OpenShell 資源，例如閘道器、提供者、沙盒、推論路由和策略。
4. **應用 (Apply)**：執行器透過呼叫 `openshell` CLI 命令來執行規劃。
5. **狀態 (Status)**：執行器報告當前狀態。

## 沙盒環境

沙盒運行
[`ghcr.io/nvidia/openshell-community/sandboxes/openclaw`](https://github.com/NVIDIA/OpenShell-Community)
容器映像。在沙盒內部：

- OpenClaw 運行時預裝了 NemoClaw 插件。
- 推論呼叫透過 OpenShell 路由到配置的提供者。
- 網路流出 (egress) 受到 `openclaw-sandbox.yaml` 中基準策略的限制。
- 檔案系統存取限於 `/sandbox` 和 `/tmp` 的讀寫權限，系統路徑為唯讀。

## 推論路由

來自代理 (agent) 的推論請求永遠不會直接離開沙盒。
OpenShell 會攔截請求並將其路由到配置的提供者：

```text
代理 (沙盒)  ──▶  OpenShell 閘道器  ──▶  提供者
                                         ├── NVIDIA 雲端 (預設)
                                         ├── 本地 NIM 服務
                                         └── localhost 上的 vLLM
```

有關提供者配置詳情，請參閱 [推論設定檔](../reference/inference-profiles_zh_TW.md)。
