# Project Skeleton Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a runnable backend and frontend skeleton for NovelCraft.

**Architecture:** Use a repository-level multi-module layout with `backend/` for Spring Boot and `frontend/` for Vue 3. The backend exposes health and placeholder API surfaces with configuration ready for OpenAI-compatible providers. The frontend provides a workspace shell and API/SSE client boundaries without implementing full domain flows yet.

**Tech Stack:** Java 21, Spring Boot 3.5.x, Spring AI 1.1.x, Maven, Vue 3, TypeScript, Vite, Vitest.

---

### Task 1: Backend Maven Skeleton

**Files:**
- Create: `backend/pom.xml`
- Create: `backend/src/main/java/com/novelcraft/NovelCraftApplication.java`
- Create: `backend/src/main/resources/application.yml`
- Create: `backend/src/test/java/com/novelcraft/NovelCraftApplicationTests.java`

- [ ] Create a Spring Boot Maven project under `backend/`.
- [ ] Add Java 21, web, validation, actuator, Spring AI OpenAI starter, MySQL driver, Flyway, and test dependencies.
- [ ] Add application configuration placeholders for database and OpenAI-compatible API settings.
- [ ] Add a context-load test.
- [ ] Run `mvn -q -DskipTests=false test` from `backend/`.

### Task 2: Backend Common API And Health Endpoint

**Files:**
- Create: `backend/src/main/java/com/novelcraft/common/api/ApiResponse.java`
- Create: `backend/src/main/java/com/novelcraft/common/api/ErrorResponse.java`
- Create: `backend/src/main/java/com/novelcraft/common/error/GlobalExceptionHandler.java`
- Create: `backend/src/main/java/com/novelcraft/health/HealthController.java`
- Create: `backend/src/test/java/com/novelcraft/health/HealthControllerTest.java`

- [ ] Write a MockMvc test for `GET /api/health`.
- [ ] Run the test and verify it fails because the controller does not exist.
- [ ] Add the controller and response wrapper.
- [ ] Run the test and verify it passes.

### Task 3: Backend AI Boundary Skeleton

**Files:**
- Create: `backend/src/main/java/com/novelcraft/config/AiProperties.java`
- Create: `backend/src/main/java/com/novelcraft/generation/application/AiGateway.java`
- Create: `backend/src/main/java/com/novelcraft/generation/application/MockAiGateway.java`
- Create: `backend/src/main/java/com/novelcraft/generation/controller/GenerationController.java`
- Create: `backend/src/test/java/com/novelcraft/generation/controller/GenerationControllerTest.java`

- [ ] Write a MockMvc test for `GET /api/generation/demo/stream` expecting SSE events.
- [ ] Run the test and verify it fails because the endpoint does not exist.
- [ ] Add AI properties and gateway interface.
- [ ] Add a mock streaming gateway for development profile-independent skeleton behavior.
- [ ] Add SSE demo endpoint returning `metadata`, `delta`, and `completed` events.
- [ ] Run the test and verify it passes.

### Task 4: Frontend Vite Skeleton

**Files:**
- Create: `frontend/package.json`
- Create: `frontend/index.html`
- Create: `frontend/tsconfig.json`
- Create: `frontend/tsconfig.node.json`
- Create: `frontend/vite.config.ts`
- Create: `frontend/vitest.config.ts`
- Create: `frontend/src/main.ts`
- Create: `frontend/src/App.vue`
- Create: `frontend/src/style.css`
- Create: `frontend/src/api/http.ts`
- Create: `frontend/src/api/sse.ts`
- Create: `frontend/src/api/__tests__/sse.test.ts`

- [ ] Create a Vue 3 + TypeScript + Vite app under `frontend/`.
- [ ] Add Vitest and Vue test utilities.
- [ ] Write an SSE buffer utility test first.
- [ ] Run `npm test -- --run` and verify it fails because the utility does not exist.
- [ ] Implement the utility and workspace shell.
- [ ] Run frontend tests and build.

### Task 5: Repository Verification And Commit

**Files:**
- Modify: `README.md`
- Modify: `.gitignore`

- [ ] Update README with backend and frontend commands.
- [ ] Ensure `.gitignore` covers backend and frontend generated artifacts.
- [ ] Run backend tests.
- [ ] Run frontend tests.
- [ ] Run frontend build.
- [ ] Check `git status`.
- [ ] Commit and push to `origin/main`.

