---
title:
  page: "為 NemoClaw 本地推理設置本地 NIM 服務"
  nav: "設置本地 NIM"
description: "將 NemoClaw 推理路由到網絡上的 NVIDIA NIM 容器。"
keywords: ["nemoclaw local nim setup", "on-premises nim inference nemoclaw", "nemoclaw 本地 NIM 設置", "本地 NIM 推理"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "nim", "inference_routing", "containers"]
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

# 設置本地 NIM 服務

將推理路由到運行在本地網絡中的 NVIDIA NIM 容器。
此配置文件在保留所有推理於本地的同時，使用與 NVIDIA 雲端相同的模型。

## 前置條件

- 一個運行中的 NemoClaw 沙盒。
- Docker 或兼容的容器運行時。
- 具有足夠 VRAM 以運行目標模型的 GPU。
- 用於拉取 NIM 容器鏡像的 NVIDIA NGC API 金鑰。

## 拉取並啟動 NIM 容器

拉取 NIM 容器鏡像並在 8000 端口啟動它：

```console
$ docker run -d --gpus all \
    -p 8000:8000 \
    --name nim-service \
    nvcr.io/nim/nvidia/nemotron-3-super-120b-a12b:latest
```

等待容器日誌顯示模型已加載並準備好提供服務。
使用以下命令檢查日誌：

```console
$ docker logs -f nim-service
```

## 驗證 NIM 服務

確認 NIM 容器可以訪問：

```console
$ curl http://nim-service.local:8000/v1/models
```

如果 `nim-service.local` 無法解析，請使用容器的 IP 地址或配置 DNS 來解析主機名。

## 設置 NIM API 金鑰

導出 `NIM_API_KEY` 環境變量。
`nim-local` 配置文件使用此變量向 NIM 服務進行身份驗證：

```console
$ export NIM_API_KEY=<your-nim-api-key>
```

## 切換到 NIM 提供者

將活動推理提供者設置為 `nim-local`：

```console
$ openshell inference set --provider nim-local --model nvidia/nemotron-3-super-120b-a12b
```

更改立即生效。
無需重啟沙盒。

## 驗證推理路由

檢查沙盒狀態以確認活動提供者：

```console
$ openclaw nemoclaw status
```

輸出應顯示 `nim-local` 作為活動提供者，端點為 `nim-service.local:8000`。

## 網絡策略

沙盒網絡策略包含一個 `nim_service` 條目，允許流量發往 `nim-service.local:8000`。
此條目是 `nemoclaw-blueprint/policies/openclaw-sandbox.yaml` 中基準策略的一部分。
無需額外的策略更改。

## 啟動時選擇 NIM 配置文件

要使用 `nim-local` 配置文件啟動新的沙盒，請在啟動時傳遞 `--profile nim-local`：

```console
$ openclaw nemoclaw launch --profile nim-local
```

## 相關主題

- [切換推理提供者](switch-inference-providers_zh_TW.md) 以在運行時更改提供者。
- [推理配置文件](../reference/inference-profiles_zh_TW.md) 獲取完整的配置文件規範。
- [網絡策略](../reference/network-policies_zh_TW.md) 獲取 `nim_service` 策略條目。
