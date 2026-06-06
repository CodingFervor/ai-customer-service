# AI Customer Service

## English | [中文](#中文)

An AI-powered customer service platform built with Go, Gin, PostgreSQL, and Redis.

### Features
- Multi-channel support (Web, WeChat, Email, SMS, APP)
- AI chatbot with intent recognition and NLU
- Knowledge base management (FAQ, articles, documents)
- Human agent takeover and routing
- Conversation history and context management
- Ticket management system
- Customer satisfaction surveys
- Real-time chat with WebSocket
- Intelligent FAQ auto-reply
- Multi-language support
- Analytics dashboard and reports

### Tech Stack
- Go 1.22 + Gin
- PostgreSQL 16
- Redis 7
- JWT Authentication
- Docker Compose

### Quick Start

```bash
# Start dependencies
docker-compose up -d

# Run the server
go run cmd/api/main.go
```

### API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/v1/auth/login | Agent login |
| GET | /api/v1/chat/ws | WebSocket chat |
| POST | /api/v1/chat/send | Send message |
| GET | /api/v1/conversations | List conversations |
| GET | /api/v1/knowledge-base | List knowledge base |
| POST | /api/v1/knowledge-base | Add to knowledge base |
| POST | /api/v1/tickets | Create ticket |
| GET | /api/v1/tickets | List tickets |
| GET | /api/v1/analytics/overview | Analytics overview |

---

<a id="中文"></a>
# AI 智能客服系统

基于 Go + Gin + PostgreSQL + Redis 构建的 AI 智能客服平台。

### 功能特性
- 多渠道支持（网页、微信、邮件、短信、APP）
- AI 聊天机器人，意图识别和 NLU
- 知识库管理（FAQ、文章、文档）
- 人工客服接入和路由
- 对话历史和上下文管理
- 工单管理系统
- 客户满意度调查
- WebSocket 实时聊天
- 智能FAQ自动回复
- 多语言支持
- 分析仪表板和报表

### 技术栈
- Go 1.22 + Gin
- PostgreSQL 16
- Redis 7
- JWT 认证
- Docker Compose

### 快速开始

```bash
# 启动依赖服务
docker-compose up -d

# 运行服务
go run cmd/api/main.go
```

### API 接口

| 方法 | 路径 | 描述 |
|------|------|------|
| POST | /api/v1/auth/login | 客服登录 |
| GET | /api/v1/chat/ws | WebSocket 聊天 |
| POST | /api/v1/chat/send | 发送消息 |
| GET | /api/v1/conversations | 对话列表 |
| GET | /api/v1/knowledge-base | 知识库列表 |
| POST | /api/v1/knowledge-base | 添加知识 |
| POST | /api/v1/tickets | 创建工单 |
| GET | /api/v1/tickets | 工单列表 |
| GET | /api/v1/analytics/overview | 分析概览 |
