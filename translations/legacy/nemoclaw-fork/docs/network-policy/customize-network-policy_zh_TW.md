---
title:
  page: "自定義 NemoClaw 沙盒網絡策略"
  nav: "自定義網絡策略"
description: "在沙盒策略中添加、刪除或修改允許的端點。"
keywords: ["customize nemoclaw network policy", "sandbox egress policy configuration"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "network_policy", "security", "nemoclaw"]
content:
  type: how_to
  difficulty: intermediate
  audience: ["developer", "engineer", "security_engineer"]
status: published
---

<!--
  SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0
-->

# 自定義沙盒網絡策略

添加、刪除或修改沙盒允許訪問的端點。
NemoClaw 支持在重啟後持續存在的靜態策略更改，以及對運行的沙盒進行動態更新。

## 先決條件

- 進行動態更改需要正在運行的 NemoClaw 沙盒，進行靜態更改需要 NemoClaw 源代碼存儲庫。
- `PATH` 中已包含 OpenShell CLI。

## 靜態更改

靜態更改會修改基線策略文件，並在下一次沙盒創建時生效。

### 編輯策略文件

開啟 `nemoclaw-blueprint/policies/openclaw-sandbox.yaml` 並添加或修改端點條目。

`network` 部分中的每個條目都定義了一個端點群組，包含以下欄位：

`endpoints` (端點)
: 沙盒可以訪問的主機和端口對。

`binaries` (二進制文件)
: 允許使用此端點的可執行文件。

`rules` (規則)
: 允許使用的 HTTP 方法和路徑。

### 重新運行引導 (Onboard)

通過重新運行引導精靈來應用更新後的策略：

```console
$ nemoclaw onboard
```

精靈會讀取修改後的策略文件並將其應用於沙盒。

### 驗證策略

檢查沙盒是否正在使用更新後的策略運行：

```console
$ openclaw nemoclaw status
```

## 動態更改

動態更改可在不重啟的情況下對運行的沙盒應用策略更新。

### 創建策略文件

創建一個包含要添加端點的 YAML 文件。
遵循與 `nemoclaw-blueprint/policies/openclaw-sandbox.yaml` 中基線策略相同的格式。

### 應用策略

使用 OpenShell CLI 應用策略更新：

```console
$ openshell policy set <policy-file>
```

更改將立即生效。

### 動態更改的範圍

動態更改僅適用於當前會話。
當沙盒停止時，運行策略將重置為策略文件中定義的基線。
要使更改永久生效，請更新靜態策略文件並重新運行設置。

## 相關主題

- [批准或拒絕代理網絡請求](approve-network-requests_zh_TW.md) 以進行操作員即時審批。
- [網絡策略](../reference/network-policies_zh_TW.md) 以獲取完整的基線策略參考。
