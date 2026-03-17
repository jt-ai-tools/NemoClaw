---
title:
  page: "NemoClaw 網絡策略 — 基準規則與操作員審批"
  nav: "網絡策略"
description: "基準網絡策略、文件系統規則與操作員審批流程。"
keywords: ["nemoclaw network policy", "sandbox egress control operator approval", "nemoclaw 網絡策略", "沙盒出口控制操作員審批"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "sandboxing", "network_policy", "security"]
content:
  type: reference
  difficulty: intermediate
  audience: ["developer", "engineer", "security_engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 網絡策略

NemoClaw 運行時採用默認嚴格的網絡策略。
沙盒僅能訪問被明確允許的端點。
任何對未列出目的地的請求都會被 OpenShell 攔截，並提示操作員通過 TUI 即時批准或拒絕。

## 基準策略

基準策略定義在 `nemoclaw-blueprint/policies/openclaw-sandbox.yaml` 中。

### 文件系統

| 路徑 | 訪問權限 |
|---|---|
| `/sandbox`, `/tmp`, `/dev/null` | 讀寫 |
| `/usr`, `/lib`, `/proc`, `/dev/urandom`, `/app`, `/etc`, `/var/log` | 唯讀 |

沙盒進程作為專用的 `sandbox` 用戶和組運行。
Landlock LSM 強制執行基於最佳努力原則。

### 網絡策略

默認允許以下端點組：

:::{list-table}
:header-rows: 1
:widths: 20 30 20 30

* - 策略
  - 端點
  - 二進制文件
  - 規則

* - `claude_code`
  - `api.anthropic.com:443`, `statsig.anthropic.com:443`, `sentry.io:443`
  - `/usr/local/bin/claude`
  - 所有方法

* - `nvidia`
  - `integrate.api.nvidia.com:443`, `inference-api.nvidia.com:443`
  - `/usr/local/bin/claude`, `/usr/local/bin/openclaw`
  - 所有方法

* - `github`
  - `github.com:443`
  - `/usr/bin/gh`, `/usr/bin/git`
  - 所有方法，所有路徑

* - `github_rest_api`
  - `api.github.com:443`
  - `/usr/bin/gh`
  - GET, POST, PATCH, PUT, DELETE

* - `clawhub`
  - `clawhub.com:443`
  - `/usr/local/bin/openclaw`
  - GET, POST

* - `openclaw_api`
  - `openclaw.ai:443`
  - `/usr/local/bin/openclaw`
  - GET, POST

* - `openclaw_docs`
  - `docs.openclaw.ai:443`
  - `/usr/local/bin/openclaw`
  - 僅 GET

* - `npm_registry`
  - `registry.npmjs.org:443`
  - `/usr/local/bin/openclaw`, `/usr/local/bin/npm`
  - 僅 GET

* - `telegram`
  - `api.telegram.org:443`
  - 任何二進制文件
  - `/bot*/**` 上的 GET, POST

:::

所有端點均使用 TLS 終端，並在 443 端口強制執行。

### 推理

基準策略僅允許 `local`（本地）推理路由。外部推理提供者通過 OpenShell 網關訪問，而不是通過沙盒直接出口。

## 操作員審批流程

當代理嘗試訪問策略中未列出的端點時，OpenShell 會攔截請求並將其呈現在 TUI 中供操作員審核：

1. 代理對未列出的主機發起網絡請求。
2. OpenShell 攔截連接並記錄該嘗試。
3. TUI 命令 `openshell term` 顯示被攔截的請求，包括主機、端口和請求的二進制文件。
4. 操作員批准或拒絕該請求。
5. 如果獲得批准，該端點將被添加到該會話的運行策略中。

要嘗試此功能，請運行演示腳本：

```console
$ ./scripts/walkthrough.sh
```

這將開啟一個分割的 tmux 會話，左側為 TUI，右側為代理。

## 修改策略

### 靜態更改

編輯 `nemoclaw-blueprint/policies/openclaw-sandbox.yaml` 並重新運行配置嚮導：

```console
$ nemoclaw onboard
```

### 動態更改

在不重啟的情況下向運行中的沙盒應用策略更新：

```console
$ openshell policy set <policy-file>
```
