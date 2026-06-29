# ONE

> AI 原生效率助理 — macOS App

[![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)](https://github.com/whoishzp/one-app/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-lightgrey.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/swift-5.9%2B-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

ONE 是一个面向 AI 原生用户的个人效率助理，集成定时提醒、AI 对话反馈、知识管理和开发工具，常驻 Dock 和 Menu Bar。

## 功能模块

### [定时提醒](docs/reminders.md)

建立规律的工作节奏。支持循环、定点、一次三种触发方式，全屏蒙层强制打断，8 套主题风格可选。可配置倒计时锁定、跟进提醒、定时脚本执行。含下班模式（全屏黑幕 + 密码保护 + 全局快捷键）。

### [CursorGood](docs/cursorgood.md)

Cursor IDE 的 AI Agent 持续交互通道。Agent 通过 MCP 发送进度和问题，你在 ONE 窗口中查看并回复。支持多会话并行、快捷回复按钮、Markdown 渲染、图片粘贴、历史消息分页、聊天导出。

### [OneMind](docs/onemind.md)

个人知识管理系统。知识库 → 文件夹 → 文档三层结构，左侧目录树管理内容，右侧所见即所得编辑器（Tiptap）支持富文本、Slash 命令、图片、文档大纲。节点支持自定义 Emoji/图标和拖动排序。

### [Soldier](docs/soldier.md)

远程本地在线助手。通过飞书等接入端接收消息，调度 Claude / Cursor Agent 执行任务。支持 Soldier 配置管理、接入端锁定、专属系统提示词、消息记录查看。

### [Fe 助手](docs/fehelper.md)

前端开发常用工具集：JSON 美化（树形展开 + 嵌套解析）、JSON 比对（双面板高亮差异）、信息编码转换（18 种编解码）、时间戳转换（智能解析 + 快捷操作）。

### [系统设置](docs/settings.md)

全局配置：4 套主题色 + 自定义配色、背景图 + 透明度调节、开机自启、启动命令、AI Skill 管理、GitHub 云同步（自动/手动上传 + 恢复）。

## 安装

### 下载安装包（推荐）

1. 前往 [Releases](https://github.com/whoishzp/one/releases) 下载最新 `.dmg`
2. 打开 DMG，将 `ONE.app` 拖入 `Applications` 文件夹
3. 首次运行在「系统设置 → 安全性 → 仍然打开」中允许

### 从源码构建

```bash
git clone git@github.com:whoishzp/one.git
cd one
./build.sh
open ONE.app
```

## 系统要求

| 项目 | 要求 |
|---|---|
| macOS | 13.0 (Ventura) 或更高 |
| 架构 | Apple Silicon / Intel |

## 更新日志

完整版本历史见 [CHANGELOG.md](CHANGELOG.md)。

## License

[Proprietary](LICENSE) — All rights reserved.
