---
title:
  page: "NemoClaw 工作原理 — 外掛程式、藍圖和沙箱生命週期"
  nav: "工作原理"
description: "外掛程式、藍圖、沙箱建立和推論路由概念。"
keywords: ["nemoclaw 工作原理", "nemoclaw 沙箱生命週期藍圖"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "sandboxing", "inference_routing", "blueprints", "network_policy"]
content:
  type: concept
  difficulty: technical_beginner
  audience: ["developer", "engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# NemoClaw 工作原理

NemoClaw 結合了輕量級 CLI 外掛程式與版本化藍圖，將 OpenClaw 移入受控的沙箱中。
本頁面從高層次解釋核心概念。

## 外掛程式與藍圖

NemoClaw 分為兩個部分：

- *外掛程式* (plugin) 是一個 TypeScript 套件，在 `openclaw nemoclaw` 命名空間下為 OpenClaw CLI 新增指令。
  它處理使用者互動，並將編排工作委託給藍圖。
- *藍圖* (blueprint) 是一個版本化的 Python 成品，包含建立沙箱、套用策略和配置推論的所有邏輯。
  外掛程式會解析、驗證並以子程序方式執行藍圖。

這種分離保持了外掛程式的小巧與穩定，同時允許藍圖按照自己的發佈節奏進行演進。

## 沙箱建立

當您執行 `openclaw nemoclaw launch` 時，NemoClaw 會建立一個 OpenShell 沙箱，在隔離的容器中執行 OpenClaw。
藍圖透過 OpenShell CLI 編排此過程：

1. 外掛程式下載藍圖成品，檢查版本相容性，並驗證摘要 (digest)。
2. 藍圖確定要建立或更新哪些 OpenShell 資源，例如閘道器、推論提供者、沙箱和網路策略。
3. 藍圖呼叫 OpenShell CLI 指令來建立沙箱並配置各個資源。

沙箱啟動後，代理 (agent) 將在其中執行，並受到所有網路、檔案系統和推論控制的約束。

## 推論路由

來自代理的推論請求絕不會直接離開沙箱。
OpenShell 會攔截每一次推論呼叫，並將其路由到配置的提供者。
NemoClaw 附帶三種推論設定檔：

- NVIDIA 雲端：透過 [build.nvidia.com](https://build.nvidia.com) 路由到 Nemotron 3 Super 120B。
- 本地 NIM：路由到您本地網路上的 NIM 容器。
- 本地 vLLM：路由到 localhost 上的 vLLM 伺服器，用於離線開發。

您可以在執行階段切換提供者，而無需重新啟動沙箱。

## 網路與檔案系統策略

沙箱啟動時會套用 `openclaw-sandbox.yaml` 中定義的嚴格基準策略。
此策略控制代理可以存取的網路端點和檔案系統路徑。

- 對於網路，僅允許策略中列出的端點。
  當代理嘗試存取未列出的主機時，OpenShell 會封鎖請求，並在 TUI 中顯示以供操作員核准。
- 對於檔案系統，代理可以寫入 `/sandbox` 和 `/tmp`。
  所有其他系統路徑均為唯讀。

核准的端點在目前工作階段中持續有效，但不會儲存到基準策略檔案中。

## 下一步

- 按照 [快速入門](../get-started/quickstart_zh_TW.md) 啟動您的第一個沙箱。
- 參考 [架構](../reference/architecture_zh_TW.md) 以瞭解完整的技術結構，包括檔案佈局和藍圖生命週期。
- 參考 [推論設定檔](../reference/inference-profiles_zh_TW.md) 以瞭解詳細的提供者配置。
