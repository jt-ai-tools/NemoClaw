---
title:
  page: "在運行時切換 NemoClaw 推論提供者"
  nav: "切換推論提供者"
description: "在不重啟沙盒的情況下更改當前的推論提供者。"
keywords: ["切換 nemoclaw 推論提供者", "運行時更改推論"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "inference_routing", "nim", "vllm"]
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

# 在運行時切換推論提供者

在沙盒運行期間更改活動的推論提供者。
不需要重新啟動。

## 前置條件

- 正在運行的 NemoClaw 沙盒。
- OpenShell CLI 已在您的 `PATH` 中。

## 切換到 NVIDIA Cloud

將提供者設置為 `nvidia-nim` 並指定來自 [build.nvidia.com](https://build.nvidia.com) 的模型：

```console
$ openshell inference set --provider nvidia-nim --model nvidia/nemotron-3-super-120b-a12b
```

此配置需要 `NVIDIA_API_KEY` 環境變量。
`nemoclaw onboard` 命令會在首次運行時將此金鑰存儲在 `~/.nemoclaw/credentials.json` 中。

## 切換到本地 vLLM

將提供者設置為 `vllm-local` 並指定主機上由 vLLM 提供服務的模型：

```console
$ openshell inference set --provider vllm-local --model nvidia/nemotron-3-nano-30b-a3b
```

在切換之前，vLLM 服務器必須已在運行。
將服務器綁定到 `0.0.0.0` 並確保主機防火牆允許橋接子網訪問端口 `8000`。
請參考 [設置本地 vLLM](set-up-local-vllm_zh_TW.md) 獲取設置說明。

## 切換到本地 NIM

將提供者設置為 `nim-local` 並指定網絡上由 NIM 容器提供服務的模型：

```console
$ openshell inference set --provider nim-local --model nvidia/nemotron-3-super-120b-a12b
```

此配置需要 `NIM_API_KEY` 環境變量。
請參考 [設置本地 NIM 服務](set-up-local-nim_zh_TW.md) 獲取設置說明。

## 驗證活動提供者

運行狀態命令以確認更改：

```console
$ openclaw nemoclaw status
```

添加 `--json` 標誌以獲得機器可讀的輸出：

```console
$ openclaw nemoclaw status --json
```

輸出包括活動的提供者、模型和端點。

## 可用模型

下表列出了已在 `nvidia-nim` 提供者中註冊的模型。
您可以在運行時切換到這些模型中的任何一個。

| 模型 ID | 標籤 | 上下文視窗 | 最大輸出 |
|---|---|---|---|
| `nvidia/nemotron-3-super-120b-a12b` | Nemotron 3 Super 120B | 131,072 | 8,192 |
| `nvidia/llama-3.1-nemotron-ultra-253b-v1` | Nemotron Ultra 253B | 131,072 | 4,096 |
| `nvidia/llama-3.3-nemotron-super-49b-v1.5` | Nemotron Super 49B v1.5 | 131,072 | 4,096 |
| `nvidia/nemotron-3-nano-30b-a3b` | Nemotron 3 Nano 30B | 131,072 | 4,096 |

## 相關主題

- [推論配置](../reference/inference-profiles_zh_TW.md) 獲取完整的配置詳細信息。
- [設置本地 vLLM](set-up-local-vllm_zh_TW.md) 用於使用 vLLM 進行離線開發。
- [設置本地 NIM 服務](set-up-local-nim_zh_TW.md) 用於本地 NIM 部署。
