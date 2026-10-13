---
title:
  page: "為 NemoClaw 離線開發設置本地 vLLM"
  nav: "設置本地 vLLM"
description: "通過將推論路由到本地 vLLM 服務器來離線運行 NemoClaw。"
keywords: ["nemoclaw 本地 vllm 設置", "離線推論 vllm nemoclaw"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "vllm", "inference_routing", "local_development"]
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

# 為離線開發設置本地 vLLM

通過將推論路由到本地機器上的 vLLM 服務器，完全離線運行 NemoClaw。
此配置不需要 NVIDIA API 金鑰或雲端端點的網路存取。
OpenShell 將請求從網關路由到主機，因此提供者端點必須可以從主機迴環接口（loopback interface）之外訪問。

## 前置條件

- 正在運行的 NemoClaw 沙盒。
- 具有足夠 VRAM 供目標模型使用的 GPU。
- Python 3.10 或更高版本。
- 已安裝 `vllm` Python 套件。

## 啟動 vLLM 服務器

在 8000 端口啟動使用 Nemotron 3 Nano 30B 模型的 vLLM 服務器：

```console
$ python -m vllm.entrypoints.openai.api_server \
    --model nvidia/nemotron-3-nano-30b-a3b \
    --host 0.0.0.0 \
    --port 8000
```

等待服務器日誌顯示模型已加載並準備好接受請求。

## 驗證服務器

通過查詢其模型端點來確認 vLLM 服務器是否可訪問：

```console
$ curl http://localhost:8000/v1/models
```

響應應將 `nvidia/nemotron-3-nano-30b-a3b` 列為可用模型。

## 網關可達性

OpenShell 為本地 OpenAI 兼容的提供者配置了一個主機可見的端點，例如 `http://host.openshell.internal:8000/v1`。
不要在提供者記錄中使用 `localhost` 或 `127.0.0.1`，因為這些地址在網關運行時內部解析，而不是在您的工作站上解析。

如果您的主機使用 UFW，請在切換提供者之前允許來自 Docker 橋接子網的 vLLM 端口：

```console
$ sudo ufw allow proto tcp from 172.18.0.0/16 to any port 8000 comment 'Allow OpenShell cluster to vLLM'
$ sudo ufw allow proto tcp from 172.17.0.0/16 to any port 8000 comment 'Allow Docker bridge to vLLM'
```

## 切換到 vLLM 提供者

將活動推論提供者設置為 `vllm-local`：

```console
$ openshell inference set --provider vllm-local --model nvidia/nemotron-3-nano-30b-a3b
```

`vllm` 配置使用 `OPENAI_API_KEY` 環境變量。
對於本地使用，此值默認為 `dummy`，不需要設置。
提供者端點為 `http://host.openshell.internal:8000/v1`。

## 測試推論

從沙盒內部運行測試推論請求：

```console
$ nemoclaw my-assistant connect
$ openclaw agent --agent main --local -m "Hello, are you running locally?" --session-id test
```

## 啟動時選擇 vLLM 配置

要從一開始就使用 vLLM 配置啟動新沙盒，請在啟動期間傳遞 `--profile vllm`：

```console
$ openclaw nemoclaw launch --profile vllm
```

## 相關主題

- [在運行時切換推論提供者](switch-inference-providers_zh_TW.md) 以更改提供者。
- [推論配置](../reference/inference-profiles_zh_TW.md) 獲取完整的配置規範。
