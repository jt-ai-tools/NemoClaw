---
title:
  page: "NemoClaw 概觀 — 功能與組成"
  nav: "概觀"
description: "NemoClaw 透過 NVIDIA 推論和宣告式策略為 OpenClaw 提供沙箱環境。"
keywords: ["nemoclaw 概觀", "openclaw openshell 沙箱外掛程式"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "sandboxing", "inference_routing", "blueprints"]
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

# 概觀

NemoClaw 是專為 [NVIDIA OpenShell](https://github.com/NVIDIA/OpenShell) 設計的 [OpenClaw](https://openclaw.ai) 外掛程式。
它將 OpenClaw 移至沙箱環境中，使每一次網路請求、檔案存取和推論呼叫都受到宣告式策略的約束。

## NemoClaw 的功能

- 為 OpenClaw 提供沙箱。建立預先配置為 OpenClaw 使用的 OpenShell 沙箱，從首次啟動起即套用嚴格的檔案系統和網路策略。
- 透過 NVIDIA 進行推論路由。配置 OpenShell 推論路由，使代理流量根據所選的設定檔，流經雲端託管的 Nemotron 3 Super 120B、本地 NIM 服務或 vLLM。
- 管理生命週期。處理藍圖版本控制、摘要驗證和沙箱設定。

## 系統組成

NemoClaw 是一個輕量級的 TypeScript 外掛程式，在 `openclaw nemoclaw` 命名空間下註冊指令。
它將繁重的編排工作委託給版本化的藍圖（一個 Python 成品），透過 OpenShell CLI 指揮沙箱建立、策略套用和推論提供者配置。

```{mermaid}
flowchart TB
    subgraph Host
        CMD["openclaw nemoclaw launch"]
        PLUGIN[nemoclaw plugin]
        BLUEPRINT[blueprint runner]
        CLI["openshell CLI\nsandbox · gateway · inference · policy"]

        CMD --> PLUGIN
        PLUGIN --> BLUEPRINT
        BLUEPRINT --> CLI
    end

    subgraph Sandbox["OpenShell Sandbox"]
        AGENT[OpenClaw agent]
        INF[NVIDIA 推論，路由中]
        NET[嚴格網路策略]
        FS[檔案系統隔離]

        AGENT --- INF
        AGENT --- NET
        AGENT --- FS
    end

    PLUGIN --> AGENT

    classDef nv fill:#76b900,stroke:#333,color:#fff
    classDef nvLight fill:#e6f2cc,stroke:#76b900,color:#1a1a1a
    classDef nvDark fill:#333,stroke:#76b900,color:#fff

    class CMD,PLUGIN,BLUEPRINT nvDark
    class CLI nv
    class AGENT nv
    class INF,NET,FS nvLight

    style Host fill:none,stroke:#76b900,stroke-width:2px,color:#1a1a1a
    style Sandbox fill:#f5faed,stroke:#76b900,stroke-width:2px,color:#1a1a1a
```

## 設計原則

輕量外掛程式，版本化藍圖
: 外掛程式保持小巧穩定。編排邏輯存在於藍圖中，並按照自己的發佈節奏演進。

尊重 CLI 邊界
: 外掛程式指令位於 `nemoclaw` 命名空間下，絕不覆寫 OpenClaw 內建指令。

供應鏈安全
: 藍圖成品是不可變且具備版本的，在執行前會經過摘要驗證。

全新安裝原生支援 OpenShell
: 對於沒有現有 OpenClaw 安裝的使用者，NemoClaw 建議直接使用 `openshell sandbox create`，而非強制進行由外掛程式驅動的引導設定。

可重現的設定
: 再次執行設定將從相同的藍圖和策略定義重新建立沙箱。
