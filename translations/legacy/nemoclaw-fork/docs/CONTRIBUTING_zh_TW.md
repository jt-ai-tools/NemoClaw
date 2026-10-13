# 貢獻 NemoClaw 說明文件

本指南說明如何撰寫、編輯及審查 NemoClaw 的說明文件。如果您更改了影響使用者行為的程式碼，請在同一個 PR 中更新相關文件。

## 使用 Agent Skills

如果您使用 AI 編碼代理 (Cursor, Claude Code, Codex 等)，本儲存庫包含可自動化文件工作的 Skills。在從頭開始編寫之前，請先使用它們。

| Skill | 功能 | 使用時機 |
|---|---|---|
| `update-docs-from-commits` | 掃描最近的提交 (commits) 以找出面向使用者的變更，並起草文件更新。 | 在功能上線後、發布版本前，或為了找出文件缺失時。 |

這些 Skills 位於 `.agents/skills/` 並會自動遵循下方的風格指南。若要使用，請要求您的代理運行它。例如，要求它「補上自 v0.2.0 以來合併的所有內容的文件」。

## 何時更新文件

當您的變更符合以下情況時，請更新說明文件：

- 新增、移除或重新命名 CLI 命令或旗標 (flag)。
- 更改預設行為或配置。
- 新增使用者會互動的新功能。
- 修復了說明文件中描述錯誤的 Bug。
- 更改了 API、協定或策略架構 (policy schema)。

## 在本地建置文件

建置文件並檢查輸出來驗證文件是否正確建置。

若要建置文件，請執行：

```bash
make docs
```

若要在本地提供文件並在變更時自動重新建置，請執行：

```bash
make docs-live
```

## 撰寫規範

### 格式

- 說明文件使用 [MyST Markdown](https://myst-parser.readthedocs.io/)，這是一個與 Sphinx 相容的 CommonMark 超集。
- 每一頁都以 YAML frontmatter (標題、描述、主題、標籤、內容類型) 開始。
- 在 frontmatter 之後包含 SPDX 授權標頭：
  ```
  <!--
    SPDX-FileCopyrightText: Copyright (c) 2025-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
    SPDX-License-Identifier: Apache-2.0
  -->
  ```

### Frontmatter 範本

```yaml
---
title:
  page: "NemoClaw 頁面標題 — 帶有情境的副標題"
  nav: "簡短導覽標題"
description: "該頁面的一句話摘要。"
keywords: ["主要關鍵字", "次要關鍵字片語"]
topics: ["generative_ai", "ai_agents"]
tags: ["openclaw", "openshell", "相關", "標籤"]
content:
  type: concept | how_to | get_started | tutorial | reference
  difficulty: technical_beginner | technical_intermediate | technical_advanced
  audience: ["developer", "engineer"]
status: published
---
```

### 頁面結構

1. 與 `title.page` 值匹配的 H1 標題。
2. 一、兩句話的簡介，說明該頁面涵蓋的內容。
3. 按任務或概念組織的章節，使用 H2 和 H3。每個章節都以一個引導讀者的介紹句開始。
4. 底部有一個「後續步驟」章節，連結到相關頁面。

## 風格指南

撰寫時就像在向同事解釋事情一樣。直接、具體且簡明扼要。

### 語氣與語調

- 使用主動語態。「CLI 建立了一個閘道 (gateway)」而不是「閘道是由 CLI 建立的」。
- 稱呼讀者時使用第二人稱 (「您」)。
- 使用現在式。「該命令返回錯誤」而不是「該命令將返回錯誤」。
- 陳述事實。不要使用「簡單地」、「只是」、「輕鬆地」或「當然」等詞彙來迴避。

### 應避免的事項

這些模式在 LLM 生成的文本中很常見，會降低技術讀者的信任。請在審查期間將其移除。

| 模式 | 問題 | 修正 |
|---|---|---|
| 不必要的粗體 | 在常規指令中使用「這是一個 **關鍵** 步驟」。 | 將粗體保留給 UI 標籤、參數名稱和真正的警告。 |
| 到處都是破折號 | 「閘道 — 運行在 Docker 中 — 建立了沙盒。」 | 使用逗號或拆分為兩個句子。破折號可以適量使用，但不應在每個段落中多次出現。 |
| 誇大詞 | 「OpenShell 提供強大、穩健且無縫的體驗。」 | 說明它的功能，而不是它有多偉大。 |
| 模糊詞 | 「只需運行命令」或「您可以輕鬆配置...」 | 去掉副詞。改為「運行命令」。 |
| 正文中的表情符號 | 「讓我們開始吧！」 | 說明文件正文中不使用表情符號。 |
| 反問句 | 「想要保護您的代理嗎？看這裡就對了！」 | 直接陳述目的。 |

### 格式規則

- 每個句子都以句點結尾。
- 原始檔中每行一個句子 (使 diff 易於閱讀)。
- 對於 CLI 命令、檔案路徑、旗標、參數名稱和值，請使用 `code` 格式。
- 對於 CLI 範例，請使用 `console` 語言的程式碼區塊。命令前綴為 `$`：
  ```console
  $ nemoclaw onboard
  ```
- 使用表格進行結構化比較。保持表格簡單 (無嵌套格式)。
- 對於註釋請使用 MyST 警告框 (`:::{tip}`, `:::{note}`, `:::{warning}`)，而不是粗體文字。
- 避免嵌套警告框。
- 不要為章節標題編號。寫成「部署閘道」而不是「第 1 節：部署閘道」或「步驟 3：驗證」。
- 不要在標題中使用冒號。寫成「部署與管理閘道」而不是「閘道：部署與管理」。
- 僅在引導列表時使用冒號。不要將冒號用作子句之間的通用標點符號。

### 用詞表

請一致使用以下用詞：

| 使用 | 不要使用 |
|---|---|
| gateway (閘道) | Gateway (除非在句首) |
| sandbox (沙盒) | Sandbox (除非在句首) |
| CLI | cli, Cli |
| API key (API 金鑰) | api key, API Key |
| NVIDIA | Nvidia, nvidia |
| NemoClaw | nemoclaw (在正文中), Nemoclaw |
| OpenClaw | openclaw (在正文中), Openclaw |
| OpenShell | Open Shell, openShell, Openshell, openshell |
| mTLS | MTLS, mtls |
| YAML | yaml, Yaml |

## 提交文件變更

1. 遵循專案慣例建立分支。
2. 進行變更。
3. 使用 `make docs` 在本地建置並驗證輸出。
4. 開啟 PR，並使用 `docs:` 作為 conventional commit 類型。

```
docs: 更新新 onboard 嚮導的快速入門
```

如果您的文件變更隨附於程式碼變更，請將兩者包含在同一個 PR 中，並使用程式碼變更的提交類型：

```
feat(cli): 新增 policy-add 命令
```

## 審查文件 PR

審查說明文件時：

- 檢查是否遵循上述風格指南規則。
- 注意 LLM 生成的模式 (過度粗體、破折號、填充詞)。
- 驗證程式碼範例是否準確且可執行。
- 確認交叉引用和連結沒有斷開。
- 在本地建置以檢查渲染效果。
