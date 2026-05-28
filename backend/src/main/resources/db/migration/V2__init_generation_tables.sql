CREATE TABLE generation_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    source_type VARCHAR(60) NULL,
    source_id BIGINT NULL,
    request_type VARCHAR(80) NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'pending',
    provider VARCHAR(80) NOT NULL DEFAULT 'openai-compatible',
    model VARCHAR(120) NOT NULL,
    temperature DECIMAL(4, 2) NULL,
    max_tokens INT NULL,
    prompt_snapshot LONGTEXT NULL,
    context_snapshot LONGTEXT NULL,
    output LONGTEXT NULL,
    error_message TEXT NULL,
    started_at DATETIME(6) NULL,
    completed_at DATETIME(6) NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_generation_task_work_type_status_created (work_id, request_type, status, created_at),
    KEY idx_generation_task_source (source_type, source_id),
    CONSTRAINT fk_generation_task_work FOREIGN KEY (work_id) REFERENCES work (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE content_version (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    source_type VARCHAR(60) NOT NULL,
    source_id BIGINT NOT NULL,
    version_no INT NOT NULL,
    title VARCHAR(200) NULL,
    content LONGTEXT NOT NULL,
    change_reason VARCHAR(500) NULL,
    generation_task_id BIGINT NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_content_version_source_version (source_type, source_id, version_no),
    KEY idx_content_version_work_created (work_id, created_at),
    KEY idx_content_version_generation_task (generation_task_id),
    CONSTRAINT fk_content_version_work FOREIGN KEY (work_id) REFERENCES work (id),
    CONSTRAINT fk_content_version_generation_task FOREIGN KEY (generation_task_id) REFERENCES generation_task (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE consistency_issue (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    generation_task_id BIGINT NULL,
    severity VARCHAR(40) NOT NULL,
    source_reference VARCHAR(500) NULL,
    description TEXT NOT NULL,
    suggestion TEXT NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_consistency_issue_work_severity_created (work_id, severity, created_at),
    KEY idx_consistency_issue_generation_task (generation_task_id),
    CONSTRAINT fk_consistency_issue_work FOREIGN KEY (work_id) REFERENCES work (id),
    CONSTRAINT fk_consistency_issue_generation_task FOREIGN KEY (generation_task_id) REFERENCES generation_task (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
