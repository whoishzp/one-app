# Soldier — 远程本地在线助手

## 概述

Soldier 是 ONE 应用的远程助手模块，用户通过手机端（飞书）向本地电脑的 AI Agent（Cursor / Claude）发送指令，实现远程控制和智能问答。

## 核心功能

### 飞书消息接入

- 飞书 WebSocket 长连接，实时接收私聊消息
- 纯 Swift 实现（手写 protobuf 解析），无第三方依赖
- 自动重连（指数退避），断网恢复后自动恢复连接
- 支持文本消息、富文本消息解析

### 消息聚合

- **结束词触发**：用户说「好了」「处理吧」等结束词后立即发送给 Agent
- **超时触发**：超过设定时间（默认 60 秒）无新消息自动发送
- **多条合并**：连续发来的多条消息自动编号合并为一条 prompt
- 结束词本身不会发送给 Agent（消费掉）

### Cursor Agent 集成

- 通过 Cursor CLI（`cursor agent`）调用，支持 `--resume` 会话续接
- 通过 CursorGood MCP 实现多轮交互：Agent 主动调用 CG → 消息转发到飞书 → 用户回复注入 Agent
- **自动规则注入**：启动前将 CursorGood 行为规则和用户自定义规则（`~/.cursor/rules/*.mdc`）注入 prompt
- **自动 MCP 配置**：启动前在工作区自动创建 `.cursor/mcp.json`，确保 Agent 可发现 CursorGood
- 可选指定 Cursor 模型和模式（Agent/Plan/Ask）

### Claude 集成

- 通过 Claude CLI（`claude -p`）调用，支持 `--resume` 会话续接
- 自定义系统提示词追加在 CLAUDE.md 前面
- 可选指定 Claude 模型
- 自动管理会话 session ID，支持重置

### Agent 执行过程可视化

- **统一 Block 协议**：Cursor/Claude 两条链路的 stream 数据统一为 AgentUIBlock 格式
- **专用卡片视图**：MCP 调用卡片（参数 + 结果）、Diff 差异卡片（语法高亮 + 行号）、工具调用分组卡片
- **实时流式渲染**：Agent 执行过程中实时展示思考、工具调用、输出等
- **Diff 滚动**：差异内容过多时最高 356pt，支持上下左右滚动

### 飞书回复

- Agent 回复自动转换为飞书消息卡片（Markdown → 卡片元素）
- CursorGood 中间消息转发到飞书（仅正文，不含快捷选项）
- 代码块、标题、普通文本分别适配卡片格式
- 单卡片超过 50 元素自动分批发送
- 发送失败时自动降级为纯文本

### 双输入通道

- **飞书**：手机端发消息 → 飞书回复
- **ONE 本地输入框**：在消息记录页直接输入 → 仅写入消息记录

两个通道共享聚合器，体验一致。

## 配置说明

### 接入端配置

| 配置项 | 说明 |
| --- | --- |
| App ID | 飞书开放平台应用 ID |
| App Secret | 飞书开放平台应用密钥 |
| User OpenID | 只接收指定用户的消息（留空接收全部） |

飞书开放平台需启用「长连接接收事件」并订阅 `im.message.receive_v1`。

### Agent 配置

| 配置项 | 说明 |
| --- | --- |
| Agent 类型 | Cursor 或 Claude |
| 工作目录 | Agent CLI 的工作目录 |
| 模型 | 可选指定模型（留空使用默认） |
| 模式 | Cursor 专属：Agent/Plan/Ask |
| 聚合超时 | 10~300 秒，默认 60 秒 |
| 结束词 | 自定义结束词列表 |

### 系统提示词

专属提示词编辑器，内容追加在 Agent 系统提示词最前面。

## 数据存储

| 文件 | 内容 |
| --- | --- |
| `~/.one/data/soldiers.json` | Soldier 配置 |
| `~/.one/data/soldier-messages.json` | 消息记录 |
| `~/.one/data/soldier-logs/` | 运行日志 |
| `~/one-soldier/{名称}/` | 分层记忆目录 |

所有数据通过 `ONEDataStore` 持久化，支持 GitHub 云同步。
