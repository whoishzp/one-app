# Soldier — 远程本地在线助手

## 概述

Soldier 是 ONE 应用的分层 Agent 模块，实现用户通过手机端（飞书等）控制本地电脑，完成远程在线助手功能。

## 架构

Soldier 采用六层架构设计：

| 层级 | 名称 | 职责 |
|---|---|---|
| 1 | 端接入层 | 接收飞书/钉钉等上游端消息 |
| 2 | 消息预处理层 | 关键词聚合、延迟转发策略 |
| 3 | 消息记录层 | 统一存储所有交互消息流水 |
| 4 | 提示词工程层 | 组装 Soldier 级 + 全局系统提示词 |
| 5 | Agent 调度层 | 根据配置调度 Claude / Cursor |
| 6 | 工具层 | 全局工具配置与授权管理 |

## 功能

### Soldier 配置

- 以流式卡片网格展示所有已配置的 Soldier
- 每个 Soldier 独立配置：名称、头像、接入端、Agent、提示词
- 支持新建、编辑、删除

### 接入端配置

- 当前支持飞书（WebSocket 长连接）
- 配置项：App ID、App Secret
- 确认后接入端类型永久锁定

### Agent 配置

- 可选 Claude 或 Cursor
- 确认后 Agent 类型永久锁定

### 提示词配置

- 专属系统提示词编辑器
- 追加在 Agent 系统提示词最前面

### 消息记录

- 左侧 Soldier 列表 + 右侧消息流水
- 支持用户消息、Agent 回复、系统消息三种类型
- 仅查看，不支持从此处发送消息

### 工具配置

- 预留入口，后续实现

## 数据存储

- 配置数据：`~/.one/data/soldiers.json`
- 消息数据：`~/.one/data/soldier-messages.json`
- 通过 `ONEDataStore` 持久化，支持 GitHub 云同步

## 文件结构

```
Sources/Settings/Soldier/
├── SoldierMainView.swift        # 主帧（SubTab 切换）
├── SoldierConfigView.swift      # 配置子帧（卡片网格）
├── SoldierEditSheet.swift       # 配置弹窗
├── SoldierEndpointPanel.swift   # 接入端配置面板
├── SoldierAgentPanel.swift      # Agent 配置面板
├── SoldierPromptPanel.swift     # 提示词配置面板
├── SoldierToolsPanel.swift      # 工具配置占位
├── SoldierMessagesView.swift    # 消息记录主视图
└── SoldierMessageBubble.swift   # 消息气泡组件

Sources/Models/
├── SoldierConfig.swift          # 配置数据模型
├── SoldierStore.swift           # 数据管理 Store
└── SoldierMessage.swift         # 消息数据模型
```
