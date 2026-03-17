---
title:
  page: "NemoClaw 推論設定檔 — NVIDIA Cloud, NIM, and vLLM"
  nav: "推論設定檔"
description: "NVIDIA 雲端、本地 NIM 和 vLLM 設定檔的配置參考。"
keywords: ["nemoclaw inference profiles", "nemoclaw nvidia nim vllm provider", "NemoClaw 推論設定檔", "NemoClaw NVIDIA NIM vLLM 提供者"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "inference_routing", "nim", "vllm", "llms"]
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

# 推論設定檔

NemoClaw 隨附了在 `blueprint.yaml` 中定義的三個推論設定檔。
每個設定檔都配置了一個 OpenShell 推論提供者和模型路由。
沙盒內的代理會使用當前啟用的設定檔。
推論請求會透明地透過 OpenShell 閘道器進行路由。

## 設定檔摘要

| 設定檔 | 提供者 | 模型 | 端點 | 使用場景 |
|---|---|---|---|---|
| `default` | NVIDIA 雲端 | `nvidia/nemotron-3-super-120b-a12b` | `integrate.api.nvidia.com` | 生產環境。需要 NVIDIA API 金鑰。 |
| `nim-local` | 本地 NIM 服務 | `nvidia/nemotron-3-super-120b-a12b` | `nim-service.local:8000` | 地端。NIM 作為本地 pod 部署。 |
| `vllm` | vLLM | `nvidia/nemotron-3-nano-30b-a3b` | `host.openshell.internal:8000` | 本地開發。主機上的 vLLM。 |

## 可用模型

`nvidia-nim` 提供者註冊了來自 [build.nvidia.com](https://build.nvidia.com) 的以下模型：

| 模型 ID | 標籤 | 上下文視窗 | 最大輸出 |
|---|---|---|---|
| `nvidia/nemotron-3-super-120b-a12b` | Nemotron 3 Super 120B | 131,072 | 8,192 |
| `nvidia/llama-3.1-nemotron-ultra-253b-v1` | Nemotron Ultra 253B | 131,072 | 4,096 |
| `nvidia/llama-3.3-nemotron-super-49b-v1.5` | Nemotron Super 49B v1.5 | 131,072 | 4,096 |
| `nvidia/nemotron-3-nano-30b-a3b` | Nemotron 3 Nano 30B | 131,072 | 4,096 |

`default` 和 `nim-local` 設定檔使用 Nemotron 3 Super 120B。
`vllm` 設定檔使用 Nemotron 3 Nano 30B。
您可以在運行時切換到目錄中的任何模型。

## `default` -- NVIDIA 雲端

預設設定檔透過 [build.nvidia.com](https://build.nvidia.com) 將推論路由到 NVIDIA 託管的 API。

- **提供者類型：** `nvidia`
- **端點：** `https://integrate.api.nvidia.com/v1`
- **模型：** `nvidia/nemotron-3-super-120b-a12b`
- **憑證：** `NVIDIA_API_KEY` 環境變數

從 [build.nvidia.com](https://build.nvidia.com) 獲取 API 金鑰。
`nemoclaw onboard` 命令會提示輸入此金鑰並將其存儲在 `~/.nemoclaw/credentials.json` 中。

```console
$ openshell inference set --provider nvidia-nim --model nvidia/nemotron-3-super-120b-a12b
```

## `nim-local` -- 本地 NIM 服務

將推論路由到在本地網路運行的 NIM 容器。

- **提供者類型：** `openai` (使用相容於 OpenAI 的 API)
- **端點：** `http://nim-service.local:8000/v1`
- **模型：** `nvidia/nemotron-3-super-120b-a12b`
- **憑證：** `NIM_API_KEY` 環境變數

沙盒網路策略包含一個 `nim_service` 條目，允許流量通向 `nim-service.local:8000`。

```console
$ openshell inference set --provider nim-local --model nvidia/nemotron-3-super-120b-a12b
```

## `vllm` -- 本地 vLLM

將推論路由到在主機上運行並暴露給 OpenShell 閘道器的 vLLM 伺服器。

- **提供者類型：** `openai` (使用相容於 OpenAI 的 API)
- **端點：** `http://host.openshell.internal:8000/v1`
- **模型：** `nvidia/nemotron-3-nano-30b-a3b`
- **憑證：** `OPENAI_API_KEY` 環境變數。本地使用時預設為 `dummy`。

啟動 vLLM 伺服器時使用非回環 (non-loopback) 綁定地址，例如 `0.0.0.0`。
在啟用了 UFW 的 Linux 主機上，允許 Docker 橋接子網訪問 `8000` 端口。

```console
$ openshell inference set --provider vllm-local --model nvidia/nemotron-3-nano-30b-a3b
```

## 在啟動時選擇設定檔

在啟動時傳遞 `--profile` 以選擇設定檔：

```console
$ openclaw nemoclaw launch --profile vllm
```

## 在運行時切換設定檔

沙盒運行後，使用 OpenShell CLI 切換推論提供者：

```console
$ openshell inference set --provider <provider-name> --model <model-name>
```

更改將立即生效。
無需重啟沙盒。
