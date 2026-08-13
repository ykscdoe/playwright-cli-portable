# playwright-cli-portable 便携包

> 🚀 **离线便携** — Playwright CLI + MCP 服务器 + Chrome 扩展，下载即用
> 📦 所有 npm 依赖已内置在 `node_modules/`，**无需联网安装**
> 🧩 附带官方 Chrome 扩展（`extension/`），可连接你已登录的浏览器会话

## 这是什么？

微软官方 [Playwright CLI](https://github.com/microsoft/playwright-cli)（`@playwright/cli`）和
[MCP 服务器](https://github.com/microsoft/playwright-mcp)（`@playwright/mcp`）的离线便携打包，
并附带了可直接加载的官方 Chrome 扩展（v0.3.0，来自 Chrome 应用商店）。

对应你的 `rules/playwright-use.md` 使用规则：`playwright-cli attach --extension`、`snapshot`、`console` 等命令。

## 系统要求

- **Node.js 18+**（仅需基础 Node 安装，本机为 v22）
- Chrome / Edge / Chromium 浏览器（可选，仅使用扩展连接时需要）

## 快速开始（Windows）

```cmd
:: 1. 验证 CLI 可用
playwright-cli.cmd --help

:: 2. 直接用本机 Chrome 打开页面（可交互）
playwright-cli.cmd open https://example.com --headed

:: 3. 连接已登录的浏览器会话（需要先装扩展，见下）
playwright-cli.cmd attach --extension=chrome
```

Linux / macOS 用 `./playwright-cli.sh` 替代。

## 安装 Chrome 扩展（连接已登录浏览器）

1. 打开 `chrome://extensions/`
2. 右上角打开 **开发者模式**
3. 点击 **加载已解压的扩展程序**，选择本包的 `extension/` 目录
4. 扩展图标出现后，点击图标 → 状态页可复制 `PLAYWRIGHT_MCP_EXTENSION_TOKEN`

> 由于官方签名 `key` 已内置，加载解压后扩展 ID 与商店版一致。
> 重新拉取最新扩展：`powershell -ExecutionPolicy Bypass -File scripts\fetch-extension.ps1`

## 在 VS Code 使用 MCP（控制浏览器）

### 方式一：一键脚本

```cmd
setup-vscode-mcp.cmd
```

脚本会备份并合并 `%APPDATA%\Code\User\mcp.json`，加入 `playwright-extension` 服务器。
然后在 VS Code 执行 `MCP: 重新加载服务器` 或重启 VS Code。

### 方式二：手动编辑 `%APPDATA%\Code\User\mcp.json`

```json
{
  "servers": {
    "playwright-extension": {
      "command": "C:\\你的路径\\playwright-cli-portable\\mcp.cmd",
      "args": ["--extension"],
      "env": { "PLAYWRIGHT_MCP_EXTENSION_TOKEN": "扩展状态页复制的令牌" },
      "type": "stdio"
    }
  }
}
```

> `env` 令牌可留空：首次连接时扩展会弹窗让你手动批准。
> 不填令牌每次连接都需批准；填了令牌可自动连接。

## 安装技能（给 Copilot / Claude 等 AI 用）

在**项目根目录**运行（技能会装到 `.claude/skills/playwright-cli`）：

```cmd
:: Windows：把 install-skills.cmd 路径填到项目里，或在项目目录执行
C:\你的路径\playwright-cli-portable\install-skills.cmd

:: 或直接执行
playwright-cli.cmd install --skills
```

## 部署到其他电脑

整包复制到目标电脑（含 `node_modules/`、`extension/`、`skills/`、`rules/`），然后：

```cmd
:: Windows（管理员）：复制到 C:\playwright-cli-portable 并可选加 PATH
install.cmd

:: Linux / macOS
bash install.sh
```

目标电脑需装 **Node.js 18+**。浏览器不打包——按规则使用目标电脑本机的 Chrome。

## 文件结构

```
playwright-cli-portable/
├── node_modules/           # 全部 npm 依赖 (CLI + MCP + playwright-core)
├── extension/              # 官方 Chrome 扩展 (可直接加载解压)
├── skills/                 # playwright-cli 技能参考 (内置)
├── rules/playwright-use.md # 你的使用规则
├── scripts/
│   ├── fetch-extension.ps1 # 重新拉取最新扩展
│   ├── setup-vscode-mcp.ps1# 配置 VS Code MCP
│   └── rebuild-deps.ps1    # 联网更新依赖版本
├── playwright-cli.cmd/.bat/.ps1/.sh   # CLI 启动器
├── mcp.cmd/.ps1/.sh                   # MCP 服务器启动器
├── install.cmd / install.sh           # 一键安装脚本
├── install-skills.cmd / install-skills.sh
├── setup-vscode-mcp.cmd               # 一键配置 VS Code MCP
└── README.md
```

## 开发者：更新依赖版本

联网时运行（会升级 `@playwright/cli` 和 `@playwright/mcp` 到最新）：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\rebuild-deps.ps1
```

## 注意事项

1. **平台兼容性**：`node_modules/` 为 npm 纯 JS 依赖，Windows/Linux/macOS 通用（Playwright 浏览器驱动按需自动下载，但本方案用本机 Chrome，无需下载）。
2. **浏览器不进包**：本设计连本机已登录的 Chrome 会话，浏览器二进制不打包（可省 150-400MB）。
3. **Node 前置**：目标电脑必须有 Node.js 18+。

## 许可证

- [@playwright/cli](https://github.com/microsoft/playwright-cli) — Apache-2.0
- [@playwright/mcp](https://github.com/microsoft/playwright-mcp) — Apache-2.0
- Playwright Extension — Apache-2.0
