---
title:
  page: "設置用於遠端代理對話的 NemoClaw Telegram 橋接器"
  nav: "設置 Telegram 橋接器"
description: "在 Telegram 和沙盒化 OpenClaw 代理之間轉發消息。"
keywords: ["nemoclaw telegram bridge", "telegram bot openclaw agent"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "telegram", "deployment", "nemoclaw"]
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

# 設置 Telegram 橋接器

在 Telegram 機器人和沙盒內運行的 OpenClaw 代理之間轉發消息。
Telegram 橋接器是由 `nemoclaw start` 管理的輔助服務。

## 先決條件

- 正在運行的 NemoClaw 沙盒（本地或遠端）。
- 來自 [BotFather](https://t.me/BotFather) 的 Telegram 機器人令牌 (Token)。

## 創建 Telegram 機器人

開啟 Telegram 並向 [@BotFather](https://t.me/BotFather) 發送 `/newbot`。
按照提示創建機器人並獲取機器人令牌。

## 設置環境變量

將機器人令牌導出為環境變量：

```console
$ export TELEGRAM_BOT_TOKEN=<您的機器人令牌>
```

## 啟動輔助服務

啟動 Telegram 橋接器和其他輔助服務：

```console
$ nemoclaw start
```

`start` 命令啟動以下服務：

- Telegram 橋接器：在 Telegram 和代理之間轉發消息。
- cloudflared 隧道：提供沙盒的外部訪問。

僅在設置了 `TELEGRAM_BOT_TOKEN` 環境變量時，Telegram 橋接器才會啟動。

## 驗證服務

檢查 Telegram 橋接器是否正在運行：

```console
$ nemoclaw status
```

輸出顯示所有輔助服務的狀態。

## 發送消息

開啟 Telegram，找到您的機器人並發送消息。
橋接器將消息轉發給沙盒內的 OpenClaw 代理，並返回代理的回應。

## 按聊天 ID 限制訪問

要限制哪些 Telegram 聊天可以與代理交互，請將 `ALLOWED_CHAT_IDS` 環境變量設置為以逗號分隔的 Telegram 聊天 ID 列表：

```console
$ export ALLOWED_CHAT_IDS="123456789,987654321"
$ nemoclaw start
```

## 停止服務

要停止 Telegram 橋接器和所有其他輔助服務：

```console
$ nemoclaw stop
```

## 相關主題

- [將 NemoClaw 部署到遠端 GPU 實例](deploy-to-remote-gpu_zh_TW.md) 以進行帶有 Telegram 支持的遠端部署。
- [命令](../reference/commands_zh_TW.md) 以獲取完整的 `start` 和 `stop` 命令參考。
