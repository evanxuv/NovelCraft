# NovelCraft

NovelCraft is an AI-assisted novel writing platform planned around Spring Boot, Spring AI, Vue 3, MySQL, and OpenAI-compatible model APIs.

The first milestone focuses on a usable MVP:

- Manage works, chapters, characters, worldbuilding, outlines, and historical versions.
- Generate and stream AI content with SSE.
- Use OpenAI-compatible API configuration so models can be switched without rewriting business code.
- Keep the architecture ready for later long-term memory through RAG, pgvector, or Milvus.

## Documents

- [Product Requirements](docs/product-requirements.md)
- [Architecture](docs/architecture.md)
- [Project Skeleton Plan](docs/superpowers/plans/2026-05-27-project-skeleton.md)

## Current Status

This repository contains the initial planning documents plus a runnable backend and frontend skeleton.

## Backend

```bash
cd backend
mvn -s ..\.mvn\settings.xml test
mvn -s ..\.mvn\settings.xml spring-boot:run
```

Useful endpoints:

- `GET /api/health`
- `GET /api/generation/demo/stream`

## Frontend

```bash
cd frontend
npm install --cache ..\.npm-cache
npm test -- --run
npm run build
npm run dev
```

The Vite dev server proxies `/api` to `http://localhost:8080`.

## Configuration

Use `.env.example` as the local configuration template. Do not commit real API keys or database passwords.
