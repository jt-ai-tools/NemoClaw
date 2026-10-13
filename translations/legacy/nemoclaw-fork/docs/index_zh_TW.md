---
title:
  page: "NVIDIA NemoClaw 開發者指南"
  nav: "NemoClaw"
description: "使用 NVIDIA 推理路由和嚴格的網絡策略對 OpenClaw 進行沙盒化。"
keywords: ["nemoclaw sandboxed ai agent", "openclaw openshell plugin"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "sandboxing", "inference_routing", "nemoclaw"]
content:
  type: get_started
  difficulty: technical_beginner
  audience: ["developer", "engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# NVIDIA NemoClaw

[English](./index.md) | [繁體中文](./index_zh_TW.md)

[![GitHub](https://img.shields.io/badge/github-repo-green?logo=github)](https://github.com/NVIDIA/NemoClaw)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue)](https://github.com/NVIDIA/NemoClaw/blob/main/LICENSE)

NemoClaw 是用於 [NVIDIA OpenShell](https://github.com/NVIDIA/OpenShell) 的 OpenClaw 插件。
它在沙盒環境中運行 OpenClaw，並配合 NVIDIA 推理，例如通過 [build.nvidia.com](https://build.nvidia.com) 提供的 Nemotron 3 Super 120B 或本地 vLLM。
沙盒執行嚴格的網絡策略和受操作員控制的出口審批。

## 快速入門

只需幾個命令即可安裝 CLI 並啟動沙盒化的 OpenClaw 實例。

```{raw} html
<style>
.nc-term {
  background: #1a1a2e;
  border-radius: 8px;
  overflow: hidden;
  margin: 1.5em 0;
  box-shadow: 0 4px 16px rgba(0,0,0,0.25);
  font-family: 'SFMono-Regular', Menlo, Monaco, Consolas, 'Liberation Mono', monospace;
  font-size: 0.875em;
  line-height: 1.8;
}
.nc-term-bar {
  background: #252545;
  padding: 10px 14px;
  display: flex;
  gap: 7px;
  align-items: center;
}
.nc-term-dot { width: 12px; height: 12px; border-radius: 50%; }
.nc-term-dot-r { background: #ff5f56; }
.nc-term-dot-y { background: #ffbd2e; }
.nc-term-dot-g { background: #27c93f; }
.nc-term-body { padding: 16px 20px; color: #d4d4d8; }
.nc-term-body .nc-ps { color: #76b900; user-select: none; }
.nc-hl { color: #76b900; font-weight: 600; }
.nc-cursor {
  display: inline-block;
  width: 2px;
  height: 1.1em;
  background: #d4d4d8;
  vertical-align: text-bottom;
  margin-left: 1px;
  animation: nc-blink 1s step-end infinite;
}
@keyframes nc-blink { 50% { opacity: 0; } }
</style>
<div class="nc-term">
  <div class="nc-term-bar">
    <span class="nc-term-dot nc-term-dot-r"></span>
    <span class="nc-term-dot nc-term-dot-y"></span>
    <span class="nc-term-dot nc-term-dot-g"></span>
  </div>
  <div class="nc-term-body">
    <div><span class="nc-ps">$ </span>git clone https://github.com/NVIDIA/NemoClaw.git</div>
    <div><span class="nc-ps">$ </span>cd NemoClaw</div>
    <div><span class="nc-ps">$ </span>./install.sh<span class="nc-cursor"></span></div>
  </div>
</div>
```

在終端中運行 `nemoclaw --help` 以查看完整的 CLI 參考。
您也可以克隆 [NemoClaw 存儲庫](https://github.com/NVIDIA/NemoClaw) 來探索插件源代碼和藍圖。

請繼續閱讀 [快速入門](get-started/quickstart_zh_TW.md) 以獲取逐步說明。

---

## 探索

::::{grid} 2 2 3 3
:gutter: 3

:::{grid-item-card} 關於 NemoClaw
:link: about/overview_zh_TW
:link-type: doc

了解 NemoClaw 的作用以及它如何將 OpenClaw 與 OpenShell 整合。

+++
{bdg-secondary}`概念`
:::

:::{grid-item-card} 快速入門
:link: get-started/quickstart_zh_TW
:link-type: doc

安裝 CLI、配置推理並啟動您的第一個沙盒化代理。

+++
{bdg-secondary}`教程`
:::

:::{grid-item-card} 命令
:link: reference/commands_zh_TW
:link-type: doc

用於啟動、連接、監控和管理沙盒的 CLI 命令。

+++
{bdg-secondary}`參考`
:::

:::{grid-item-card} 推理配置文件
:link: reference/inference-profiles_zh_TW
:link-type: doc

在 NVIDIA 雲端、本地 NIM 和 vLLM 推理後端之間切換。

+++
{bdg-secondary}`參考`
:::

:::{grid-item-card} 工作原理
:link: about/how-it-works_zh_TW
:link-type: doc

插件、藍圖、沙盒和推理路由的高層次概覽。

+++
{bdg-secondary}`概念`
:::

:::{grid-item-card} 架構
:link: reference/architecture_zh_TW
:link-type: doc

插件結構、藍圖系統和沙盒生命週期。

+++
{bdg-secondary}`參考`
:::

:::{grid-item-card} 網絡策略
:link: reference/network-policies_zh_TW
:link-type: doc

出口控制、操作員審批流程和策略配置。

+++
{bdg-secondary}`參考`
:::

:::{grid-item-card} 操作指南
:link: inference/switch-inference-providers_zh_TW
:link-type: doc

關於推理、部署和策略管理的任務導向指南。

+++
{bdg-secondary}`操作指南`
:::

::::

```{toctree}
:hidden:

首頁 <self>
```

```{toctree}
:caption: 關於 NemoClaw
:hidden:

概覽 <about/overview_zh_TW>
工作原理 <about/how-it-works_zh_TW>
版本說明 <about/release-notes_zh_TW>
```

```{toctree}
:caption: 快速入門
:hidden:

快速入門 <get-started/quickstart_zh_TW>
```

```{toctree}
:caption: 推理
:hidden:

切換推理提供者 <inference/switch-inference-providers_zh_TW>
設置本地 vLLM <inference/set-up-local-vllm_zh_TW>
設置本地 NIM 服務 <inference/set-up-local-nim_zh_TW>
```

```{toctree}
:caption: 網絡策略
:hidden:

批准或拒絕網絡請求 <network-policy/approve-network-requests_zh_TW>
自定義網絡策略 <network-policy/customize-network-policy_zh_TW>
```

```{toctree}
:caption: 部署
:hidden:

部署到遠端 GPU 實例 <deployment/deploy-to-remote-gpu_zh_TW>
設置 Telegram 橋接器 <deployment/set-up-telegram-bridge_zh_TW>
```

```{toctree}
:caption: 監控
:hidden:

監控沙盒活動 <monitoring/monitor-sandbox-activity_zh_TW>
```

```{toctree}
:caption: 參考
:hidden:

架構 <reference/architecture_zh_TW>
命令 <reference/commands_zh_TW>
推理配置文件 <reference/inference-profiles_zh_TW>
網絡策略 <reference/network-policies_zh_TW>
```

```{toctree}
:caption: 資源
:hidden:

resources/license_zh_TW
```
