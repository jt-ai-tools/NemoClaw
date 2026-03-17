---
title:
  page: "監控 NemoClaw 沙盒活動並調試問題"
  nav: "監控沙盒活動"
description: "檢查沙盒運行狀況、追蹤代理行為並診斷問題。"
keywords: ["監控 nemoclaw 沙盒", "調試 nemoclaw 代理問題"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "monitoring", "troubleshooting", "nemoclaw"]
content:
  type: how_to
  difficulty: technical_beginner
  audience: ["developer", "engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 監控沙盒活動並調試問題

結合使用 NemoClaw status、logs 和 TUI 工具來檢查沙盒運行狀況、追蹤代理行為並診斷問題。

## 前置條件

- 正在運行的 NemoClaw 沙盒。
- OpenShell CLI 已在您的 `PATH` 中。

## 檢查沙盒運行狀況

運行 status 命令以查看沙盒狀態、藍圖運行信息和活動推論配置：

```console
$ openclaw nemoclaw status
```

對於機器可讀的輸出，請添加 `--json` 標誌：

```console
$ openclaw nemoclaw status --json
```

輸出中的關鍵字段包括：

- 沙盒狀態（Sandbox state）：指示沙盒正在運行、已停止或處於錯誤狀態。
- 藍圖運行 ID（Blueprint run ID）：最近一次藍圖執行的標識符。
- 推論提供者（Inference provider）：顯示活動的提供者、模型和端點。

## 查看藍圖和沙盒日誌

從藍圖運行器和沙盒流式傳輸最近的日誌輸出：

```console
$ openclaw nemoclaw logs
```

要實時跟踪日誌輸出：

```console
$ openclaw nemoclaw logs -f
```

要顯示特定數量的日誌行：

```console
$ openclaw nemoclaw logs -n 100
```

要查看特定藍圖運行的日誌而不是最近一次的日誌：

```console
$ openclaw nemoclaw logs --run-id <id>
```

## 在 TUI 中監控網絡活動

打開 OpenShell 終端 UI 以實時查看沙盒網絡活動和流出請求：

```console
$ openshell term
```

對於遠程沙盒，請透過 SSH 連接到實例並在該處運行 `openshell term`。

TUI 顯示以下信息：

- 來自沙盒的活動網絡連接。
- 等待操作員批准的被阻止流出請求。
- 推論路由狀態。

有關處理被阻止請求的詳細信息，請參閱 [批准或拒絕代理網絡請求](../network-policy/approve-network-requests_zh_TW.md)。

## 測試推論

運行測試推論請求以驗證提供者是否正在響應：

```console
$ nemoclaw my-assistant connect
$ openclaw agent --agent main --local -m "Test inference" --session-id debug
```

如果請求失敗，請檢查以下各項：

1. 運行 `openclaw nemoclaw status` 以確認活動的提供者和端點。
2. 運行 `openclaw nemoclaw logs -f` 以查看來自藍圖運行器的錯誤消息。
3. 驗證從主機是否可以訪問推論端點。
   對於本地 vLLM 或 NIM，請確認服務器正在運行。

## 常見問題

下表列出了常見問題及其解決步驟：

| 症狀 | 解決方法 |
|---|---|
| 沙盒顯示為已停止 | 運行 `nemoclaw onboard` 重新創建沙盒。 |
| 推論請求超時 | 驗證提供者端點是否可訪問。檢查 `openclaw nemoclaw status` 以獲取活動端點。 |
| 代理無法訪問外部主機 | 使用 `openshell term` 打開 TUI 並批准被阻止的請求，或將端點添加到策略中。 |
| 藍圖運行失敗 | 運行 `openclaw nemoclaw logs --run-id <id>` 以查看失敗運行的錯誤輸出。 |

## 相關主題

- [命令](../reference/commands_zh_TW.md) 獲取完整的 CLI 參考。
- [批准或拒絕代理網絡請求](../network-policy/approve-network-requests_zh_TW.md) 獲取操作員批准流程。
- [切換推論提供者](../inference/switch-inference-providers_zh_TW.md) 以更改活動提供者。
