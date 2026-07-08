# ONE

> AI 原生效率助理 — macOS App

[![Version](https://img.shields.io/badge/version-2.0.1-blue.svg)](https://github.com/whoishzp/one-app/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-lightgrey.svg)](https://developer.apple.com/macos/)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

ONE 是一个面向 AI 原生用户的个人效率助理，集成定时提醒、AI 对话反馈、知识管理和开发工具，常驻 Dock 和 Menu Bar。

## 安装

### 一键安装（推荐）

```bash
curl -sL https://raw.githubusercontent.com/whoishzp/one-app/main/install.sh | bash
```

### 手动安装

1. 前往 [Releases](https://github.com/whoishzp/one-app/releases) 下载最新 `.dmg`
2. 打开 DMG，双击 **Install ONE.command** 完成安装
3. 如果提示无法验证，右键点击 → 打开

### 系统要求

| 项目 | 要求 |
| --- | --- |
| macOS | 13.0 (Ventura) 或更高 |
| 架构 | Apple Silicon / Intel |

## 功能

### 定时提醒

建立规律的工作节奏。支持循环、定点、一次性三种触发方式，全屏蒙层强制打断。8 套主题风格可选，可配置倒计时锁定和跟进提醒。含下班模式（全屏黑幕 + 密码保护 + 全局快捷键）。

[详细文档 →](docs/reminders.md)

### CursorGood — AI 持续交互

Cursor IDE 的 AI Agent 持续交互通道。Agent 通过 MCP 发送进度和问题，你在 ONE 窗口中查看并回复。支持多会话并行、快捷回复按钮、Markdown 渲染、图片粘贴、历史消息分页。

[详细文档 →](docs/cursorgood.md)

### Soldier — 远程助手

远程本地在线助手。通过飞书等接入端接收消息，调度 Claude / Cursor Agent 执行任务。支持 Soldier 配置管理、接入端锁定、专属系统提示词。

[详细文档 →](docs/soldier.md)

### Fe 助手 — 开发工具

前端开发常用工具集：JSON 美化（树形展开 + 嵌套解析）、JSON 比对（双面板高亮差异）、信息编码转换（18 种编解码）、时间戳转换（智能解析）。

[详细文档 →](docs/fehelper.md)

### 系统设置

全局配置：4 套主题色 + 自定义配色、背景图 + 透明度调节、开机自启、AI Skill 管理、GitHub 云同步。

[详细文档 →](docs/settings.md)

## 自动更新

应用内置自动更新检测，启动时自动检查新版本。也可在系统设置中手动检查。

## 更新日志

[CHANGELOG.md](CHANGELOG.md)

## License

Proprietary — All rights reserved.
