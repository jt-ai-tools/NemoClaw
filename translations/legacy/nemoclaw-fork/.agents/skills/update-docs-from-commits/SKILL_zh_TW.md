---
name: update-docs-from-commits
description: 掃描最近的 git 提交 (commits) 以找出影響使用者行為的變更，然後起草或更新相應的說明文件頁面。當說明文件落後於程式碼變更、在一批功能上線後或準備發布版本時使用。觸發關鍵字 - 更新文件, 起草文件, 來自提交的文件, 同步文件, 補上文件, 文件債, 文件落後, 文件偏移。
---

# 從提交中更新文件

掃描最近的 git 歷史記錄中影響使用者行為的提交，並為每個提交起草說明文件更新。

## 前提條件

- 您必須位於 NemoClaw 的 git 儲存庫 (`NemoClaw`) 中。
- `docs/` 目錄必須存在，且包含目前的文件集。

## 使用時機

- 在一批功能或修復上線後，且文件可能已經過時。
- 在發布版本前，以找出任何文件缺失。
- 當貢獻者詢問「哪些文件需要更新？」時。

## 步驟 1：識別相關提交

確定提交範圍。使用者可能會明確提供一個範圍 (例如，「自 v0.1.0 以來」或「最近 30 個提交」)。如果沒有，預設為自 main 分支頂端以來的提交。

```bash
# 自某個標籤 (tag) 以來的提交
git log v0.1.0..HEAD --oneline --no-merges

# 或最近 50 個提交
git log -50 --oneline --no-merges
```

篩選出可能影響文件的提交。尋找以下訊號：

1. **提交類型**：`feat`、`fix`、`refactor`、`perf` 提交通常會改變行為。`docs` 提交本身就是文件變更。`chore`、`ci`、`test` 提交很少需要更新文件。
2. **變更的檔案**：對 `nemoclaw/src/`、`nemoclaw-blueprint/`、`bin/`、`scripts/` 或策略相關程式碼的變更具有高度相關性。
3. **忽略**：僅限於 `test/`、`.github/` 或內部模組的變更。

```bash
# 顯示每個提交中變更的檔案以評估影響
git log v0.1.0..HEAD --oneline --no-merges --name-only
```

## 步驟 2：將提交對應到文件頁面

對於每個相關的提交，確定它影響哪個文件頁面。使用此對應關係作為起點：

| 程式碼區域 | 可能的文件頁面 |
|---|---|
| `nemoclaw/src/commands/` (launch, connect, status, logs) | `docs/reference/commands_zh_TW.md` |
| `nemoclaw/src/commands/` (新命令) | 可能需要新頁面或在 `docs/reference/commands_zh_TW.md` 中新增條目 |
| `nemoclaw/src/blueprint/` | `docs/reference/architecture_zh_TW.md` |
| `nemoclaw/src/cli.ts` 或 `nemoclaw/src/index.ts` | `docs/reference/commands_zh_TW.md`, `docs/get-started/quickstart_zh_TW.md` |
| `nemoclaw-blueprint/orchestrator/` | `docs/reference/architecture_zh_TW.md` |
| `nemoclaw-blueprint/policies/` | `docs/reference/network-policies_zh_TW.md` |
| `nemoclaw-blueprint/blueprint.yaml` | `docs/reference/architecture_zh_TW.md`, `docs/reference/inference-profiles_zh_TW.md` |
| `scripts/` (setup, start) | `docs/get-started/quickstart_zh_TW.md` |
| `Dockerfile` | `docs/reference/architecture_zh_TW.md` |
| 與推論 (Inference) 相關的變更 | `docs/reference/inference-profiles_zh_TW.md` |

如果提交未對應到任何現有頁面，但引入了使用者可見的概念，請將其標記為需要新頁面。

## 步驟 3：讀取提交詳情

對於每個需要更新文件的提交，讀取完整的 diff 以了解變更：

```bash
git show <commit-hash> --stat
git show <commit-hash>
```

提取：

- 變更了什麼 (新旗標、重新命名的命令、更改的預設值、新功能)。
- 為什麼變更 (來自提交消息正文、連結的 issue 或 PR 描述)。
- 任何破壞性變更 (breaking changes) 或遷移步驟。

## 步驟 4：讀取目前的文件頁面

在編輯之前，讀取目標文件頁面的全文，以了解其目前的內容和結構。

確定新內容應該放在哪裡。遵循頁面現有的結構。

## 步驟 5：起草更新

遵循以下規範撰寫文件更新：

- **主動語態、現在式、第二人稱。**
- **不要使用不必要的粗體。** 將粗體保留給 UI 標籤和參數名稱。
- **不要使用破折號**，除非少量使用。優先使用逗號或將句子拆分。
- **章節以引導讀者的介紹句開始。**
- **不要使用誇大詞。** 說明功能的作用，而不是它有多偉大。
- **程式碼範例使用 `console` 語言** 並帶有 `$` 提示符前綴。
- **如果是建立新頁面，請包含 SPDX 標頭。**
- **如果是建立新頁面，請匹配現有的 frontmatter 格式。**
- **NVIDIA 務必全部大寫。** 錯誤：Nvidia, nvidia。
- **NemoClaw 務必正確大寫。** 錯誤：nemoclaw (在正文中), Nemoclaw。
- **OpenShell 務必正確大寫。** 錯誤：openshell (在正文中), Openshell, openShell。
- **不要為章節標題編號。** 錯誤：「第 1 節：配置推論」或「步驟 3：驗證」。使用純描述性標題。
- **標題中不使用冒號。** 錯誤：「推論：雲端與本地」。改寫為「雲端與本地推論」。
- **僅在引導列表時使用冒號。** 不要將冒號用作子句之間的通用標點符號。

更新現有頁面時：

- 將內容添加到現有結構中邏輯正確的位置。
- 除非變更需要，否則不要重新組織章節。
- 如果相關，更新任何交叉引用或「後續步驟」連結。

建立新頁面時：

- 遵循 `docs/` 中現有頁面的 frontmatter 範本。
- 將頁面添加到 `docs/index_zh_TW.md` 中適當的 `toctree`。

## 步驟 6：呈現結果

起草完所有更新後，向使用者呈現摘要：

```
## 來自提交的文件更新

### 已更新頁面
- `docs/reference/commands_zh_TW.md`：新增了 `eject` 命令說明 (來自提交 abc1234)。
- `docs/reference/network-policies_zh_TW.md`：針對新的 egress 規則更新了策略架構 (來自提交 def5678)。

### 需要的新頁面
- 無 (或列出建立的所有新頁面)。

### 對文件無影響的提交
- `chore(deps): bump typescript` (abc1234) — 內部依賴項，無使用者面向的變更。
- `test: add launch command test` (def5678) — 僅限測試的變更。
```

## 步驟 7：建置並驗證

進行更改後，在本地建置文件：

```bash
make docs
```

檢查：

- 建置警告或錯誤。
- 斷開的交叉引用。
- 新內容的渲染是否正確。

## 提示

- 如果不確定提交是否需要更新文件，請檢查提交消息是否引用了 CLI 旗標、配置選項或使用者可見的行為。
- 將涉及同一個文件頁面的相關提交分組到單次更新中，而不是進行多次細微編輯。
- 如果提交是破壞性變更，請在相關章節的頂部使用 `:::{warning}` 警告框添加說明。
- 純粹的內部重構且無行為變更的 PR 不需要更新文件，即使它們涉及高度相關的目錄。

## 範例用法

使用者說：「補上自 v0.1.0 以來合併的所有內容的文件。」

1. 執行 `git log v0.1.0..HEAD --oneline --no-merges --name-only`。
2. 篩選涉及使用者面向程式碼的 `feat`、`fix`、`refactor`、`perf` 提交。
3. 將每個提交對應到一個文件頁面。
4. 讀取提交 diff 和目前的文件頁面。
5. 按照風格指南起草更新。
6. 呈現摘要。
7. 使用 `make docs` 進行建置驗證。
