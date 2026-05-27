# NovelCraft Architecture

## 1. Architecture Goals

- Build a modular monolith first, because the MVP domain is broad but does not yet justify distributed services.
- Keep AI provider access behind an application service boundary so OpenAI-compatible providers can be changed through configuration.
- Use SSE for token streaming from backend to frontend.
- Store authoritative creative data in MySQL.
- Reserve extension points for RAG, pgvector, and Milvus without making vector memory mandatory in the first release.

## 2. Proposed Technology Stack

### Backend

- Java 21.
- Spring Boot. Use Spring Boot 4.x if the selected Spring AI and project dependencies are compatible; otherwise use Spring Boot 3.5.x as the conservative baseline.
- Spring AI 1.1.x line for AI model integration and future vector store support.
- Spring Web MVC for REST and SSE.
- Spring Validation for request validation.
- Spring Data JPA or MyBatis-Plus for persistence. Recommendation: use MyBatis-Plus if the team prefers explicit SQL control; use JPA if domain relation navigation is more important.
- Flyway or Liquibase for database migrations. Recommendation: Flyway for simpler migration workflow.
- MySQL 8.x for transactional data.

### Frontend

- Vue 3.
- TypeScript.
- Vite.
- Pinia for state management.
- Vue Router.
- A UI library can be selected later; Element Plus is pragmatic for CRUD-heavy admin screens.
- Native `EventSource` or `fetch` stream wrapper for SSE consumption.

### AI Provider

- OpenAI-compatible Chat Completions or Responses-style API exposed through Spring AI where supported.
- Externalized configuration for API key, base URL, model, temperature, max tokens, and timeout.
- Provider-specific behavior isolated in `AiGateway` and prompt orchestration services.

### Future Memory

- MVP: relational context assembly from MySQL.
- Phase 2: embedding abstraction and vector memory interface.
- Phase 3 option A: PostgreSQL plus pgvector for simpler operations.
- Phase 3 option B: Milvus for larger-scale vector retrieval.

## 3. High-Level Components

```text
Vue 3 Frontend
  | REST JSON
  | SSE stream
Spring Boot Backend
  | controllers
  | application services
  | domain services
  | repositories
  | ai gateway
MySQL
OpenAI-Compatible Model Provider
Future Vector Store: pgvector or Milvus
```

## 4. Backend Package Structure

```text
com.novelcraft
  common
    api
    error
    validation
  config
    AiProperties
    WebConfig
  work
    controller
    application
    domain
    repository
    dto
  chapter
    controller
    application
    domain
    repository
    dto
  character
    controller
    application
    domain
    repository
    dto
  world
    controller
    application
    domain
    repository
    dto
  outline
    controller
    application
    domain
    repository
    dto
  generation
    controller
    application
    domain
    repository
    prompt
    stream
  consistency
    controller
    application
    dto
  version
    controller
    application
    domain
    repository
    dto
  memory
    application
    domain
    repository
```

## 5. Frontend Structure

```text
src
  api
    http.ts
    sse.ts
    workApi.ts
    chapterApi.ts
    generationApi.ts
  app
    router.ts
    store.ts
  layouts
    WorkspaceLayout.vue
  pages
    WorkListPage.vue
    WorkWorkspacePage.vue
    ChapterEditorPage.vue
  features
    work
    chapter
    character
    world
    outline
    generation
    version
  components
    common
```

## 6. Core Domain Model

### Work

- `id`
- `title`
- `genre`
- `theme`
- `synopsis`
- `styleGuide`
- `targetAudience`
- `status`
- `defaultModel`
- `createdAt`
- `updatedAt`
- `archivedAt`

### Chapter

- `id`
- `workId`
- `sequenceNo`
- `title`
- `summary`
- `content`
- `status`
- `wordCount`
- `createdAt`
- `updatedAt`
- `archivedAt`

### CharacterProfile

- `id`
- `workId`
- `name`
- `role`
- `personality`
- `motivation`
- `background`
- `appearance`
- `speechStyle`
- `relationshipsJson`
- `notes`
- `createdAt`
- `updatedAt`

### WorldEntry

- `id`
- `workId`
- `category`
- `name`
- `content`
- `tags`
- `createdAt`
- `updatedAt`

### Outline

- `id`
- `workId`
- `parentId`
- `type`
- `title`
- `content`
- `sequenceNo`
- `status`
- `createdAt`
- `updatedAt`

### ContentVersion

- `id`
- `workId`
- `sourceType`
- `sourceId`
- `versionNo`
- `title`
- `content`
- `changeReason`
- `generationTaskId`
- `createdAt`

### GenerationTask

- `id`
- `workId`
- `sourceType`
- `sourceId`
- `requestType`
- `status`
- `provider`
- `model`
- `temperature`
- `maxTokens`
- `promptSnapshot`
- `contextSnapshot`
- `output`
- `errorMessage`
- `startedAt`
- `completedAt`
- `createdAt`

### ConsistencyIssue

- `id`
- `workId`
- `generationTaskId`
- `severity`
- `sourceReference`
- `description`
- `suggestion`
- `createdAt`

## 7. API Design

### Work APIs

- `GET /api/works`
- `POST /api/works`
- `GET /api/works/{workId}`
- `PUT /api/works/{workId}`
- `POST /api/works/{workId}/archive`

### Chapter APIs

- `GET /api/works/{workId}/chapters`
- `POST /api/works/{workId}/chapters`
- `GET /api/works/{workId}/chapters/{chapterId}`
- `PUT /api/works/{workId}/chapters/{chapterId}`
- `POST /api/works/{workId}/chapters/{chapterId}/archive`
- `POST /api/works/{workId}/chapters/reorder`

### AI Generation APIs

- `POST /api/works/{workId}/generation/outlines`
- `POST /api/works/{workId}/generation/characters`
- `POST /api/works/{workId}/generation/world`
- `POST /api/works/{workId}/chapters/{chapterId}/generation/continue/stream`
- `POST /api/works/{workId}/chapters/{chapterId}/generation/polish/stream`
- `POST /api/works/{workId}/consistency/check`
- `GET /api/generation-tasks/{taskId}`

For streaming endpoints, the response content type is `text/event-stream`.

## 8. SSE Event Contract

SSE streams should use named events:

```text
event: metadata
data: {"taskId":"...","model":"..."}

event: delta
data: {"text":"generated token or chunk"}

event: heartbeat
data: {"time":"2026-05-27T10:00:00Z"}

event: error
data: {"code":"MODEL_PROVIDER_ERROR","message":"..."}

event: completed
data: {"taskId":"...","contentVersionId":"..."}
```

Backend responsibilities:

- Create a `GenerationTask` before streaming starts.
- Append chunks to an output buffer.
- Persist final output when completed.
- Mark task as failed and emit `error` when provider calls fail.
- Emit heartbeat events during long pauses.

Frontend responsibilities:

- Render `delta` chunks incrementally.
- Keep a local draft buffer separate from saved chapter content.
- Allow user to accept, discard, or save as version.
- Show task errors without losing already received chunks.

## 9. AI Integration Design

### Configuration

Use environment-specific configuration for provider settings:

```yaml
novelcraft:
  ai:
    provider: openai-compatible
    model: gpt-4.1-mini
    temperature: 0.8
    max-tokens: 4096

spring:
  ai:
    openai:
      api-key: ${OPENAI_API_KEY}
      base-url: ${OPENAI_BASE_URL:https://api.openai.com}
```

If using the Spring AI OpenAI SDK starter, align property names with the selected Spring AI version. The architecture should keep these settings wrapped by `AiProperties` so property changes do not leak into business code.

### AI Service Boundary

```text
GenerationController
  -> GenerationApplicationService
    -> PromptContextAssembler
    -> PromptTemplateService
    -> AiGateway
    -> GenerationTaskRepository
```

`AiGateway` should expose:

- `streamChat(AiRequest request): Flux<AiChunk>` or equivalent streaming abstraction.
- `completeJson(AiRequest request, Class<T> responseType)` for structured non-streaming tasks.

The rest of the application should not call Spring AI clients directly.

## 10. Prompt Context Strategy

MVP context assembly should be deterministic:

- Work synopsis and style guide.
- Current outline item.
- Current chapter summary and content excerpt.
- Previous chapter summaries, limited by count and token budget.
- Selected character profiles.
- Selected worldbuilding entries.
- User instruction.

Each generation task stores `promptSnapshot` and `contextSnapshot` for reproducibility.

## 11. Consistency Checking Strategy

MVP consistency checks use structured prompt output:

```json
{
  "issues": [
    {
      "severity": "high",
      "sourceReference": "Chapter 4, paragraph 12",
      "description": "Character age conflicts with earlier profile.",
      "suggestion": "Adjust the age reference or update the profile."
    }
  ]
}
```

The backend validates parsed output before saving issues. Invalid model JSON should be stored on the generation task and returned as a model response parsing error.

## 12. Database And Migrations

Use migration files from the first backend milestone:

```text
backend/src/main/resources/db/migration
  V1__init_core_tables.sql
  V2__init_generation_tables.sql
```

Recommended indexes:

- `chapter(work_id, sequence_no)`
- `character_profile(work_id, name)`
- `world_entry(work_id, category)`
- `outline(work_id, type, sequence_no)`
- `content_version(source_type, source_id, version_no)`
- `generation_task(work_id, request_type, status, created_at)`

## 13. Future Memory Architecture

Add memory through interfaces before choosing a vector database:

```text
MemoryIndexer
MemoryRetriever
EmbeddingGateway
VectorStoreRepository
```

Initial memory types:

- Plot memory: chapter summaries, key events, unresolved hooks.
- Character memory: stable profile facts, relationship changes, speech style examples.
- World memory: rules, locations, factions, timeline constraints.

Retrieval policy should be explicit:

- Retrieve by work ID.
- Filter by memory type.
- Rank by vector similarity plus recency or importance score.
- Limit by token budget.

## 14. Development Workflow

- Initialize Git before implementation.
- Commit documentation first.
- Add backend and frontend in separate commits.
- Keep migrations versioned.
- Use `.env.example` for required local variables.
- Do not commit real API keys.

## 15. Verification Strategy

Backend:

- Unit tests for prompt context assembly.
- Unit tests for version creation rules.
- Repository or integration tests for core CRUD flows.
- Controller tests for API validation.
- Streaming tests for SSE event order.

Frontend:

- Unit tests for SSE client buffering.
- Component tests for generation panel states.
- Manual browser verification for streaming chapter continuation.

End-to-end MVP smoke path:

1. Create work.
2. Generate outline.
3. Generate character.
4. Create chapter.
5. Stream chapter continuation.
6. Save generated text as a version.
7. Run consistency check.

