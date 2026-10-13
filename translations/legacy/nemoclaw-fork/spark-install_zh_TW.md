# 在 DGX Spark 上安裝 NemoClaw

[English](./spark-install.md) | [繁體中文](./spark-install_zh_TW.md)

> **進行中 (WIP)** — 隨著我們進行 Spark 安裝，此頁面正在積極更新。請預期會有變動。

## 快速入門

```bash
# 克隆並安裝
git clone https://github.com/NVIDIA/NemoClaw.git
cd NemoClaw
sudo npm install -g .

# Spark 特定設置（配置 Docker 的 cgroup v2，然後運行正常設置）
nemoclaw setup-spark
```

就這樣。`setup-spark` 會自動處理下面的一切。

## Spark 上的不同之處

DGX Spark 搭載 **Ubuntu 24.04 + Docker 28.x**，但沒有 k8s/k3s。OpenShell 在 Docker 容器內嵌入了 k3s，這在 Spark 上會遇到兩個問題：

### 1. Docker 權限

```
Error in the hyper legacy client: client error (Connect)
  Permission denied (os error 13)
```

**原因**：您的用戶不在 `docker` 群組中。
**修復**：`setup-spark` 運行 `usermod -aG docker $USER`。您可能需要登出並重新登錄（或運行 `newgrp docker`）才能生效。

### 2. cgroup v2 不相容

```
K8s namespace not ready
openat2 /sys/fs/cgroup/kubepods/pids.max: no
Failed to start ContainerManager: failed to initialize top level QOS containers
```

**原因**：Spark 運行 cgroup v2（Ubuntu 24.04 預設）。OpenShell 的網關容器啟動 k3s，它嘗試創建不存在的 cgroup v1 風格路徑。修復方法是在容器上使用 `--cgroupns=host`，但 OpenShell 沒有公開該標記。

**修復**：`setup-spark` 在 `/etc/docker/daemon.json` 中設置 `"default-cgroupns-mode": "host"` 並重啟 Docker。這使得所有容器都使用主機 cgroup 命名空間，這正是 k3s 所需要的。

## 先決條件

您的 Spark 上應該已經具備以下各項：

- **Docker**（預先安裝，v28.x）
- **Node.js 22** — 如果未安裝：
  ```bash
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
  ```
- **OpenShell CLI**：
  ```bash
  ARCH=$(uname -m)  # Spark 上為 aarch64
  curl -fsSL "https://github.com/NVIDIA/OpenShell/releases/latest/download/openshell-linux-${ARCH}" -o /usr/local/bin/openshell
  chmod +x /usr/local/bin/openshell
  ```
- 來自 [build.nvidia.com](https://build.nvidia.com) 的 **NVIDIA API 金鑰** — 首次運行時會提示

## 手動設置（如果 setup-spark 不起作用）

### 修復 Docker cgroup 命名空間

```bash
# 檢查您是否正在使用 cgroup v2
stat -fc %T /sys/fs/cgroup/
# 預期結果：cgroup2fs

# 將 cgroupns=host 添加到 Docker daemon 配置
sudo python3 -c "
import json, os
path = '/etc/docker/daemon.json'
d = json.load(open(path)) if os.path.exists(path) else {}
d['default-cgroupns-mode'] = 'host'
json.dump(d, open(path, 'w'), indent=2)
"

# 重啟 Docker
sudo systemctl restart docker
```

### 修復 Docker 權限

```bash
sudo usermod -aG docker $USER
newgrp docker  # 或登出並重新登錄
```

### 然後運行引導精靈

```bash
nemoclaw onboard
```

## 已知問題

| 問題 | 狀態 | 解決方法 |
|-------|--------|------------|
| cgroup v2 導致 Docker 中的 k3s 終止 | 已在 `setup-spark` 中修復 | `daemon.json` cgroupns=host |
| Docker 權限被拒絕 | 已在 `setup-spark` 中修復 | `usermod -aG docker` |
| 設置後 CoreDNS 陷入 CrashLoop | 已在 `fix-coredns.sh` 中修復 | 使用容器網關 IP，而非 127.0.0.11 |
| 鏡像拉取失敗（k3s 找不到已構建的鏡像）| OpenShell 錯誤 | `openshell gateway destroy && openshell gateway start`，重新運行設置 |
| GPU 直通 | 在 Spark 上未經測試 | 如果配置了 NVIDIA Container Toolkit，使用 `--gpu` 標記應該可以工作 |

## 驗證您的安裝

```bash
# 檢查沙盒是否正在運行
openshell sandbox list
# 應顯示：nemoclaw  Ready

# 測試代理
openshell sandbox connect nemoclaw
# 在沙盒內：
nemoclaw-start openclaw agent --agent main --local -m 'hello' --session-id test

# 監控網絡出口（在另一個終端）
openshell term
```

## 架構說明

```
DGX Spark (Ubuntu 24.04, cgroup v2)
  └── Docker (28.x, cgroupns=host)
       └── OpenShell 網關容器
            └── k3s (嵌入式)
                 └── nemoclaw 沙盒 pod
                      └── OpenClaw 代理 + NemoClaw 插件
```
