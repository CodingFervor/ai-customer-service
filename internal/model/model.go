package model

import "time"

// Agent represents a customer service agent
type Agent struct {
	ID           int64     `json:"id" db:"id"`
	Username     string    `json:"username" db:"username"`
	Password     string    `json:"-" db:"password"`
	Name         string    `json:"name" db:"name"`
	Email        string    `json:"email" db:"email"`
	Phone        string    `json:"phone" db:"phone"`
	Avatar       string    `json:"avatar" db:"avatar"`
	Department   string    `json:"department" db:"department"`
	Role         string    `json:"role" db:"role"`        // admin, supervisor, agent
	Status       string    `json:"status" db:"status"`    // online, offline, busy, away
	MaxConcurrent int      `json:"max_concurrent" db:"max_concurrent"`
	Skills       string    `json:"skills" db:"skills"`    // JSON array of skill tags
	Language     string    `json:"language" db:"language"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time `json:"updated_at" db:"updated_at"`
}

// Customer represents a customer/user
type Customer struct {
	ID           int64     `json:"id" db:"id"`
	ExternalID   string    `json:"external_id" db:"external_id"`
	Name         string    `json:"name" db:"name"`
	Email        string    `json:"email" db:"email"`
	Phone        string    `json:"phone" db:"phone"`
	Avatar       string    `json:"avatar" db:"avatar"`
	Company      string    `json:"company" db:"company"`
	VIPLevel     string    `json:"vip_level" db:"vip_level"` // none, silver, gold, platinum
	Channel      string    `json:"channel" db:"channel"`     // web, wechat, email, sms, app
	Tags         string    `json:"tags" db:"tags"`           // JSON array
	Notes        string    `json:"notes" db:"notes"`
	LastContactAt *time.Time `json:"last_contact_at" db:"last_contact_at"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time `json:"updated_at" db:"updated_at"`
}

// Conversation represents a chat conversation
type Conversation struct {
	ID            int64      `json:"id" db:"id"`
	CustomerID    int64      `json:"customer_id" db:"customer_id"`
	AgentID       *int64     `json:"agent_id" db:"agent_id"`
	Channel       string     `json:"channel" db:"channel"`     // web, wechat, email, sms, app
	Status        string     `json:"status" db:"status"`       // waiting, active, closed, transferred
	Priority      string     `json:"priority" db:"priority"`   // low, normal, high, urgent
	Subject       string     `json:"subject" db:"subject"`
	Tags          string     `json:"tags" db:"tags"`
	Source        string     `json:"source" db:"source"`       // ai_bot, human_handoff, direct
	AIBotActive   bool       `json:"ai_bot_active" db:"ai_bot_active"`
	Rating        *int       `json:"rating" db:"rating"`       // 1-5 customer satisfaction
	FirstResponseAt *time.Time `json:"first_response_at" db:"first_response_at"`
	ClosedAt      *time.Time `json:"closed_at" db:"closed_at"`
	CreatedAt     time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at" db:"updated_at"`
}

// Message represents a chat message
type Message struct {
	ID             int64     `json:"id" db:"id"`
	ConversationID int64     `json:"conversation_id" db:"conversation_id"`
	SenderType     string    `json:"sender_type" db:"sender_type"` // customer, agent, bot, system
	SenderID       int64     `json:"sender_id" db:"sender_id"`
	Content        string    `json:"content" db:"content"`
	Type           string    `json:"type" db:"type"`           // text, image, file, rich_text
	Attachments    string    `json:"attachments" db:"attachments"` // JSON array
	Intent         string    `json:"intent" db:"intent"`
	IsRead         bool      `json:"is_read" db:"is_read"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

// KnowledgeItem represents a knowledge base entry
type KnowledgeItem struct {
	ID          int64     `json:"id" db:"id"`
	Title       string    `json:"title" db:"title"`
	Content     string    `json:"content" db:"content"`
	Category    string    `json:"category" db:"category"`
	Tags        string    `json:"tags" db:"tags"`
	Type        string    `json:"type" db:"type"`         // faq, article, document, procedure
	Status      string    `json:"status" db:"status"`     // draft, published, archived
	ViewCount   int       `json:"view_count" db:"view_count"`
	HelpfulCount int      `json:"helpful_count" db:"helpful_count"`
	CreatedBy   int64     `json:"created_by" db:"created_by"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}

// FAQ represents a frequently asked question
type FAQ struct {
	ID        int64     `json:"id" db:"id"`
	Question  string    `json:"question" db:"question"`
	Answer    string    `json:"answer" db:"answer"`
	Category  string    `json:"category" db:"category"`
	Tags      string    `json:"tags" db:"tags"`
	SortOrder int       `json:"sort_order" db:"sort_order"`
	Enabled   bool      `json:"enabled" db:"enabled"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// Intent represents an AI intent for NLU
type Intent struct {
	ID          int64     `json:"id" db:"id"`
	Name        string    `json:"name" db:"name"`
	DisplayName string    `json:"display_name" db:"display_name"`
	Examples    string    `json:"examples" db:"examples"`   // JSON array of example phrases
	Responses   string    `json:"responses" db:"responses"` // JSON array of possible responses
	RequiresAgent bool    `json:"requires_agent" db:"requires_agent"`
	Priority    int       `json:"priority" db:"priority"`
	Enabled     bool      `json:"enabled" db:"enabled"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}

// Ticket represents a support ticket
type Ticket struct {
	ID          int64      `json:"id" db:"id"`
	TicketNo    string     `json:"ticket_no" db:"ticket_no"`
	CustomerID  int64      `json:"customer_id" db:"customer_id"`
	AgentID     *int64     `json:"agent_id" db:"agent_id"`
	Subject     string     `json:"subject" db:"subject"`
	Description string     `json:"description" db:"description"`
	Category    string     `json:"category" db:"category"`
	Priority    string     `json:"priority" db:"priority"`     // low, normal, high, urgent
	Status      string     `json:"status" db:"status"`         // open, in_progress, pending, resolved, closed
	Channel     string     `json:"channel" db:"channel"`
	Tags        string     `json:"tags" db:"tags"`
	Rating      *int       `json:"rating" db:"rating"`
	ResolvedAt  *time.Time `json:"resolved_at" db:"resolved_at"`
	ClosedAt    *time.Time `json:"closed_at" db:"closed_at"`
	CreatedAt   time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at" db:"updated_at"`
}

// TicketReply represents a reply in a ticket
type TicketReply struct {
	ID        int64     `json:"id" db:"id"`
	TicketID  int64     `json:"ticket_id" db:"ticket_id"`
	AuthorType string   `json:"author_type" db:"author_type"` // customer, agent, system
	AuthorID   int64    `json:"author_id" db:"author_id"`
	Content   string    `json:"content" db:"content"`
	Attachments string  `json:"attachments" db:"attachments"`
	IsInternal bool     `json:"is_internal" db:"is_internal"` // internal note
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

// Survey represents a satisfaction survey
type Survey struct {
	ID          int64     `json:"id" db:"id"`
	Title       string    `json:"title" db:"title"`
	Questions   string    `json:"questions" db:"questions"`   // JSON array of question objects
	TriggerType string    `json:"trigger_type" db:"trigger_type"` // after_conversation, after_ticket, manual
	IsActive    bool      `json:"is_active" db:"is_active"`
	CreatedBy   int64     `json:"created_by" db:"created_by"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

// SurveyResponse represents a survey submission
type SurveyResponse struct {
	ID             int64     `json:"id" db:"id"`
	SurveyID       int64     `json:"survey_id" db:"survey_id"`
	CustomerID     int64     `json:"customer_id" db:"customer_id"`
	ConversationID *int64    `json:"conversation_id" db:"conversation_id"`
	TicketID       *int64    `json:"ticket_id" db:"ticket_id"`
	Responses      string    `json:"responses" db:"responses"` // JSON
	Rating         int       `json:"rating" db:"rating"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

// QuickReply represents a canned response
type QuickReply struct {
	ID        int64     `json:"id" db:"id"`
	Title     string    `json:"title" db:"title"`
	Content   string    `json:"content" db:"content"`
	Category  string    `json:"category" db:"category"`
	SortOrder int       `json:"sort_order" db:"sort_order"`
	CreatedBy int64     `json:"created_by" db:"created_by"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// Tag represents a conversation/ticket tag
type Tag struct {
	ID        int64     `json:"id" db:"id"`
	Name      string    `json:"name" db:"name"`
	Color     string    `json:"color" db:"color"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

// Channel represents a communication channel configuration
type Channel struct {
	ID        int64     `json:"id" db:"id"`
	Name      string    `json:"name" db:"name"`
	Type      string    `json:"type" db:"type"`        // web, wechat, email, sms, app
	Config    string    `json:"config" db:"config"`    // JSON config (API keys, webhooks, etc.)
	Enabled   bool      `json:"enabled" db:"enabled"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// ChatLog represents an AI interaction log for training
type ChatLog struct {
	ID             int64     `json:"id" db:"id"`
	ConversationID int64     `json:"conversation_id" db:"conversation_id"`
	UserMessage    string    `json:"user_message" db:"user_message"`
	BotResponse    string    `json:"bot_response" db:"bot_response"`
	DetectedIntent string    `json:"detected_intent" db:"detected_intent"`
	Confidence     float64   `json:"confidence" db:"confidence"`
	WasHelpful     *bool     `json:"was_helpful" db:"was_helpful"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}
