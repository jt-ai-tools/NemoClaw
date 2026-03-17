---
title:
  page: "批准或拒絕 NemoClaw 代理網絡請求"
  nav: "批准網絡請求"
description: "在 TUI 中審核並批准被攔截的代理網絡請求。"
keywords: ["nemoclaw approve network requests", "sandbox egress approval tui"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "network_policy", "security", "nemoclaw"]
content:
  type: how_to
  difficulty: technical_beginner
  audience: ["developer", "engineer", "security_engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 批准或拒絕代理網絡請求

審核並處理代理向沙盒策略中未列出的端點發起的網絡請求。
OpenShell 攔截這些請求，並在 TUI 中呈現給操作員審批。

## 先決條件

- 正在運行的 NemoClaw 沙盒。
- `PATH` 中已包含 OpenShell CLI。

## 開啟 TUI

啟動 OpenShell 終端 UI 以監控沙盒活動：

```console
$ openshell term
```

對於遠端沙盒，請傳遞實例名稱：

```console
$ ssh my-gpu-box 'cd /home/ubuntu/nemoclaw && . .env && openshell term'
```

TUI 顯示沙盒狀態、當前推理提供者以及網絡活動的實時摘要。

## 觸發被攔截的請求

當代理嘗試訪問不在基線策略中的端點時，OpenShell 會攔截連接並在 TUI 中顯示該請求。
被攔截的請求包含以下詳細資訊：

- 目標的 **主機和端口**。
- 發起請求的 **二進制文件**。
- **HTTP 方法** 和路徑（如果可用）。

## 批准或拒絕請求

TUI 為每個被攔截的請求顯示一個審批提示。

- **批准** 請求，將該端點添加到當前會話的運行策略中。
- **拒絕** 請求，保持該端點被攔截狀態。

批准的端點會保留在運行策略中，直到沙盒停止。
它們不會持久化到基線策略文件中。

## 運行演練

要在引導會話中觀察審批流程，請運行演練腳本：

```console
$ ./scripts/walkthrough.sh
```

此腳本會開啟一個 split tmux 會話，左側為 TUI，右側為代理。
演練需要 tmux 和 `NVIDIA_API_KEY` 環境變量。

## 相關主題

- [自定義沙盒網絡策略](customize-network-policy_zh_TW.md) 以永久添加端點。
- [網絡策略](../reference/network-policies_zh_TW.md) 以獲取完整的基線策略參考。
- [監控沙盒活動](../monitoring/monitor-sandbox-activity_zh_TW.md) 以進行常規沙盒監控。
