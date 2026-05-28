CREATE TABLE work (
    id BIGINT NOT NULL AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(100) NULL,
    theme VARCHAR(200) NULL,
    synopsis TEXT NULL,
    style_guide TEXT NULL,
    target_audience VARCHAR(200) NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'draft',
    default_model VARCHAR(120) NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    archived_at DATETIME(6) NULL,
    PRIMARY KEY (id),
    KEY idx_work_status_updated_at (status, updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE chapter (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    sequence_no INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    summary TEXT NULL,
    content LONGTEXT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'draft',
    word_count INT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    archived_at DATETIME(6) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_chapter_work_sequence (work_id, sequence_no),
    KEY idx_chapter_work_status (work_id, status),
    CONSTRAINT fk_chapter_work FOREIGN KEY (work_id) REFERENCES work (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_profile (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    name VARCHAR(120) NOT NULL,
    role VARCHAR(80) NULL,
    personality TEXT NULL,
    motivation TEXT NULL,
    background TEXT NULL,
    appearance TEXT NULL,
    speech_style TEXT NULL,
    relationships_json JSON NULL,
    notes TEXT NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_character_profile_work_name (work_id, name),
    CONSTRAINT fk_character_profile_work FOREIGN KEY (work_id) REFERENCES work (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE world_entry (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    category VARCHAR(80) NOT NULL,
    name VARCHAR(160) NOT NULL,
    content TEXT NOT NULL,
    tags VARCHAR(500) NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_world_entry_work_category (work_id, category),
    CONSTRAINT fk_world_entry_work FOREIGN KEY (work_id) REFERENCES work (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE outline (
    id BIGINT NOT NULL AUTO_INCREMENT,
    work_id BIGINT NOT NULL,
    parent_id BIGINT NULL,
    type VARCHAR(40) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content LONGTEXT NULL,
    sequence_no INT NOT NULL DEFAULT 0,
    status VARCHAR(40) NOT NULL DEFAULT 'draft',
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_outline_work_type_sequence (work_id, type, sequence_no),
    KEY idx_outline_parent (parent_id),
    CONSTRAINT fk_outline_work FOREIGN KEY (work_id) REFERENCES work (id),
    CONSTRAINT fk_outline_parent FOREIGN KEY (parent_id) REFERENCES outline (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
