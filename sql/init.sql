-- AI Customer Service System - Database Schema
-- PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Agents (customer service staff)
CREATE TABLE agents (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    avatar VARCHAR(500),
    department VARCHAR(50),
    role VARCHAR(20) DEFAULT 'agent' CHECK (role IN ('admin','supervisor','agent')),
    status VARCHAR(20) DEFAULT 'offline' CHECK (status IN ('online','offline','busy','away')),
    max_concurrent INT DEFAULT 5,
    skills JSONB DEFAULT '[]',
    language VARCHAR(10) DEFAULT 'zh',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    external_id VARCHAR(100),
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    avatar VARCHAR(500),
    company VARCHAR(200),
    vip_level VARCHAR(20) DEFAULT 'none' CHECK (vip_level IN ('none','silver','gold','platinum')),
    channel VARCHAR(20) DEFAULT 'web' CHECK (channel IN ('web','wechat','email','sms','app')),
    tags JSONB DEFAULT '[]',
    notes TEXT,
    last_contact_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Conversations
CREATE TABLE conversations (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    agent_id BIGINT REFERENCES agents(id),
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('web','wechat','email','sms','app')),
    status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting','active','closed','transferred')),
    priority VARCHAR(10) DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
    subject VARCHAR(200),
    tags JSONB DEFAULT '[]',
    source VARCHAR(20) DEFAULT 'ai_bot' CHECK (source IN ('ai_bot','human_handoff','direct')),
    ai_bot_active BOOLEAN DEFAULT TRUE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    first_response_at TIMESTAMP,
    closed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_conversations_customer ON conversations(customer_id);
CREATE INDEX idx_conversations_agent ON conversations(agent_id);
CREATE INDEX idx_conversations_status ON conversations(status);

-- Messages
CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    conversation_id BIGINT NOT NULL REFERENCES conversations(id),
    sender_type VARCHAR(20) NOT NULL CHECK (sender_type IN ('customer','agent','bot','system')),
    sender_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(20) DEFAULT 'text' CHECK (type IN ('text','image','file','rich_text')),
    attachments JSONB DEFAULT '[]',
    intent VARCHAR(100),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id);

-- Knowledge base
CREATE TABLE knowledge_items (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50),
    tags JSONB DEFAULT '[]',
    type VARCHAR(20) DEFAULT 'article' CHECK (type IN ('faq','article','document','procedure')),
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
    view_count INT DEFAULT 0,
    helpful_count INT DEFAULT 0,
    created_by BIGINT REFERENCES agents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_knowledge_status ON knowledge_items(status);
CREATE INDEX idx_knowledge_category ON knowledge_items(category);

-- FAQs
CREATE TABLE faqs (
    id BIGSERIAL PRIMARY KEY,
    question VARCHAR(500) NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(50),
    tags JSONB DEFAULT '[]',
    sort_order INT DEFAULT 0,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Intents (for NLU)
CREATE TABLE intents (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(200),
    examples JSONB DEFAULT '[]',
    responses JSONB DEFAULT '[]',
    requires_agent BOOLEAN DEFAULT FALSE,
    priority INT DEFAULT 0,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tickets
CREATE TABLE tickets (
    id BIGSERIAL PRIMARY KEY,
    ticket_no VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    agent_id BIGINT REFERENCES agents(id),
    subject VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    priority VARCHAR(10) DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open','in_progress','pending','resolved','closed')),
    channel VARCHAR(20) DEFAULT 'web',
    tags JSONB DEFAULT '[]',
    rating INT CHECK (rating BETWEEN 1 AND 5),
    resolved_at TIMESTAMP,
    closed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tickets_customer ON tickets(customer_id);
CREATE INDEX idx_tickets_agent ON tickets(agent_id);
CREATE INDEX idx_tickets_status ON tickets(status);

-- Ticket replies
CREATE TABLE ticket_replies (
    id BIGSERIAL PRIMARY KEY,
    ticket_id BIGINT NOT NULL REFERENCES tickets(id),
    author_type VARCHAR(20) NOT NULL CHECK (author_type IN ('customer','agent','system')),
    author_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    attachments JSONB DEFAULT '[]',
    is_internal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ticket_replies_ticket ON ticket_replies(ticket_id);

-- Surveys
CREATE TABLE surveys (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    questions JSONB DEFAULT '[]',
    trigger_type VARCHAR(30) DEFAULT 'after_conversation' CHECK (trigger_type IN ('after_conversation','after_ticket','manual')),
    is_active BOOLEAN DEFAULT TRUE,
    created_by BIGINT REFERENCES agents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Survey responses
CREATE TABLE survey_responses (
    id BIGSERIAL PRIMARY KEY,
    survey_id BIGINT NOT NULL REFERENCES surveys(id),
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    conversation_id BIGINT REFERENCES conversations(id),
    ticket_id BIGINT REFERENCES tickets(id),
    responses JSONB DEFAULT '{}',
    rating INT CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Quick replies (canned responses)
CREATE TABLE quick_replies (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50),
    sort_order INT DEFAULT 0,
    created_by BIGINT REFERENCES agents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tags
CREATE TABLE tags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    color VARCHAR(7) DEFAULT '#666666',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Channels
CREATE TABLE channels (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('web','wechat','email','sms','app')),
    config JSONB DEFAULT '{}',
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chat AI logs (for training/improvement)
CREATE TABLE chat_logs (
    id BIGSERIAL PRIMARY KEY,
    conversation_id BIGINT NOT NULL REFERENCES conversations(id),
    user_message TEXT NOT NULL,
    bot_response TEXT,
    detected_intent VARCHAR(100),
    confidence DECIMAL(5,4),
    was_helpful BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_chat_logs_conversation ON chat_logs(conversation_id);
CREATE INDEX idx_chat_logs_intent ON chat_logs(detected_intent);

-- Insert default admin agent
INSERT INTO agents (username, password, name, email, role, status) VALUES
('admin', '$2a$10$dummyhash', 'Admin Agent', 'admin@cs.com', 'admin', 'online');

-- Insert default channels
INSERT INTO channels (name, type, config) VALUES
('Web Chat', 'web', '{}'),
('WeChat', 'wechat', '{}'),
('Email', 'email', '{}'),
('SMS', 'sms', '{}');

-- Insert sample intents
INSERT INTO intents (name, display_name, examples, responses, requires_agent) VALUES
('greeting', 'Greeting', '["hello","hi","hey","good morning"]', '["Hello! How can I help you?","Hi there! What can I do for you?"]', FALSE),
('order_query', 'Order Query', '["where is my order","check order status","order tracking"]', '["Please provide your order number so I can check the status for you."]', FALSE),
('refund', 'Refund Request', '["I want a refund","return this item","money back"]', '["I understand you want a refund. Let me connect you with a specialist."]', TRUE),
('complaint', 'Complaint', '["I am not satisfied","terrible service","complain about"]', '["I am sorry to hear that. Let me escalate this to our team."]', TRUE);
