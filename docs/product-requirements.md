# NovelCraft Product Requirements

## 1. Product Positioning

NovelCraft is an AI novel creation assistant for writers who need help planning, drafting, revising, and maintaining long-form fictional works. The product should not replace the writer's control. Its core value is structured assistance: generating reusable story assets, continuing chapters in an existing style, detecting inconsistencies, and preserving writing history.

## 2. Goals

- Provide a complete workspace for managing works, chapters, characters, worldbuilding, outlines, generated drafts, and revision history.
- Support OpenAI-compatible model APIs so the backend can switch between OpenAI, proxy services, and compatible model providers through configuration.
- Stream long-running generation results to the browser through SSE so users can read output as it is produced.
- Keep the first version practical: relational storage in MySQL, prompt orchestration in Spring AI, and clear extension points for later RAG and vector memory.
- Preserve user edits and generated variants through version history instead of overwriting important content.

## 3. Non-Goals For MVP

- Collaborative multi-user editing.
- Full text editor parity with professional writing tools.
- Automatic publishing to external platforms.
- Fine-tuning or training private models.
- Production-grade RAG memory and vector search. The architecture should reserve extension points, but MVP can use relational context assembly first.

## 4. Target Users

- Web novel writers who need help generating outlines, chapters, character profiles, and worldbuilding.
- Writers who maintain long projects and need consistency checks across chapters and settings.
- Developers or operators who want to connect different OpenAI-compatible model providers without changing application code.

## 5. MVP Feature Scope

### 5.1 Work Management

- Create, view, update, archive, and delete works.
- Store title, genre, theme, synopsis, writing style, target audience, status, and model preferences.
- Display work-level statistics such as chapter count, total word count, and last updated time.

### 5.2 Chapter Management

- Create, view, update, reorder, and archive chapters under a work.
- Store chapter title, sequence number, summary, body, status, word count, and generation metadata.
- Support draft, reviewed, and published-like internal statuses.
- Allow chapter content to be generated, continued, polished, or manually edited.

### 5.3 Character Generation And Management

- Generate character profiles from work context and user instructions.
- Store name, role, personality, motivation, background, relationships, appearance, speech style, and notes.
- Allow manual editing after generation.
- Support selecting characters as context for chapter generation.

### 5.4 Worldbuilding

- Generate and manage world settings, locations, factions, power systems, rules, timeline notes, and cultural details.
- Support work-level worldbuilding records with categories.
- Allow selected worldbuilding entries to be injected into generation prompts.

### 5.5 Outline Generation

- Generate high-level story outlines from premise, genre, target length, and user constraints.
- Generate volume-level or arc-level outlines.
- Generate chapter-level outline drafts.
- Allow accepting, editing, regenerating, or saving outline versions.

### 5.6 Chapter Continuation

- Continue a chapter from its existing body, current outline, selected characters, and recent chapter summaries.
- Stream generated content to the frontend with SSE.
- Let users stop generation from the browser.
- Save the final generated output as a new chapter version after user confirmation.

### 5.7 Polish And Rewrite

- Rewrite selected chapter content using instructions such as "more suspense", "more concise", "more literary", or custom user guidance.
- Preserve the original content.
- Save generated rewrites as version candidates.

### 5.8 Consistency Check

- Check selected chapters against known character, worldbuilding, outline, and prior chapter summaries.
- Report potential contradictions with severity, affected location, explanation, and suggested fix.
- MVP can use prompt-based checking over selected relational context. Later versions can enrich this with vector retrieval.

### 5.9 Historical Versions

- Save historical versions for chapters, outlines, generated assets, and important AI outputs.
- Record source type, source ID, content snapshot, prompt, model, provider, generation parameters, creator, and timestamp.
- Allow comparing and restoring chapter versions.

### 5.10 AI Generation Task History

- Record generation task status, request type, prompt snapshot, model parameters, token usage if available, error message, and generated output.
- Support auditing why a piece of content was generated.

## 6. User Workflows

### 6.1 Create A New Work

1. User creates a work with title, genre, premise, target style, and optional model settings.
2. User asks AI to generate worldbuilding, major characters, and a rough outline.
3. User edits and saves accepted assets.
4. User generates a chapter outline and then drafts the first chapter.

### 6.2 Continue A Chapter

1. User opens a chapter.
2. Frontend loads recent chapters, selected outline items, characters, and worldbuilding entries.
3. User enters continuation instructions.
4. Backend creates an AI generation task and starts streaming model output through SSE.
5. User watches text appear in real time.
6. User accepts the output, saves it as a new version, or discards it.

### 6.3 Check Plot Contradictions

1. User selects a work scope, such as current chapter, recent chapters, or whole outline.
2. Backend assembles structured context.
3. AI returns a structured inconsistency report.
4. User applies suggestions manually or sends selected text to rewrite.

## 7. Functional Requirements

- The backend must expose REST APIs for CRUD operations.
- The backend must expose SSE endpoints for streaming AI output.
- The AI provider must be configured through external configuration, including base URL, API key, model name, timeout, and generation parameters.
- Prompts must be versioned or stored with generation task records.
- Core domain data must be persisted in MySQL.
- Soft delete or archive behavior should be used for important creative assets.
- All generated content that changes user-facing writing should be recoverable through versions.

## 8. Non-Functional Requirements

- Generation endpoints should return quickly with a task ID or stream connection rather than blocking the browser until completion.
- SSE streams should send structured events: metadata, delta, error, completed, and heartbeat.
- API errors should use a consistent response format.
- Model provider failures should be recorded in task history.
- Secrets such as API keys must only be provided by environment variables or external configuration.
- The system should be designed so vector memory can be introduced without rewriting the work and chapter domain model.

## 9. Data Ownership And Security

- MVP may use a single-user or simple account model, but database tables should include audit fields that can support multi-user expansion.
- API keys must never be stored in frontend code.
- Generated outputs and prompts should be treated as private user data.

## 10. Suggested Milestones

### Milestone 1: Documentation And Repository Foundation

- Product requirements document.
- Architecture document.
- Git repository initialization.
- Initial README.

### Milestone 2: Backend MVP Skeleton

- Spring Boot project setup.
- MySQL schema migrations.
- Domain CRUD APIs for works, chapters, characters, worldbuilding, outlines, and versions.
- API response and error conventions.

### Milestone 3: AI Streaming MVP

- Spring AI integration with OpenAI-compatible configuration.
- Prompt templates for outline, character, worldbuilding, chapter continuation, polish, and consistency check.
- SSE streaming endpoint.
- AI generation task persistence.

### Milestone 4: Frontend MVP

- Vue 3 project setup.
- Work dashboard.
- Chapter editor view.
- AI generation panel with streaming output.
- Version history panel.

### Milestone 5: Memory Extension

- Chapter summary pipeline.
- Embedding abstraction.
- Optional pgvector or Milvus vector store.
- Retrieval policies for plot memory and character memory.

## 11. Open Decisions

- Whether to use Spring Boot 4.x immediately or start with a more conservative Spring Boot 3.x baseline depending on dependency compatibility.
- Whether the first UI should use Element Plus, Naive UI, or a custom component layer.
- Whether authentication is needed in MVP or postponed until after single-user local deployment works.
- Whether to implement vector memory first with PostgreSQL plus pgvector or keep MySQL for transactional data and add Milvus separately later.

