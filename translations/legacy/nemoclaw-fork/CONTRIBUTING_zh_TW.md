# 貢獻指南

[English](./CONTRIBUTING.md) | [繁體中文](./CONTRIBUTING_zh_TW.md)

## 簽署您的工作

* 我們要求所有貢獻者在提交 (commit) 時進行「簽署 (sign-off)」。這證明該貢獻是您的原創作品，或者您有權在相同的授權協議或相容的授權協議下提交它。

  * 任何包含未簽署提交的貢獻將不被接受。

* 要簽署提交，您只需在提交更改時使用 `--signoff` (或 `-s`) 選項：

  ```bash
  git commit -s -m "添加酷炫功能。"
  ```

  這將在您的提交消息中附加以下內容：

  ```text
  Signed-off-by: Your Name <your@email.com>
  ```

* DCO 的全文：

  ```text
    Developer Certificate of Origin
    Version 1.1

    Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
    1 Letterman Drive
    Suite D4700
    San Francisco, CA, 94129

    Everyone is permitted to copy and distribute verbatim copies of this
    license document, but changing it is not allowed.
  ```

  ```text
    開發者原創證明 (Developer's Certificate of Origin) 1.1

    透過向本專案做出貢獻，我證明：

    (a) 該貢獻全部或部分由我創建，且我有權在文件指示的開源授權協議下提交它；或者

    (b) 該貢獻基於之前的作品，據我所知，該作品受適當的開源授權協議保護，且根據該授權協議，我有權提交帶有修改的作品（無論全部或部分由我創建），並在相同的開源授權協議下（除非我被允許在不同的授權協議下提交），如文件中所示；或者

    (c) 該貢獻由其他證明 (a)、(b) 或 (c) 的人直接提供給我，且我未對其進行修改。

    (d) 我理解並同意本專案和該貢獻是公開的，且該貢獻的記錄（包括我隨之提交的所有個人資訊，包括我的簽署）將無限期保留，並可能與本專案或涉及的開源授權協議保持一致地重新分發。
  ```
