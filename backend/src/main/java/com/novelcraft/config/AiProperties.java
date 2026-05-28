package com.novelcraft.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "novelcraft.ai")
public record AiProperties(
    String provider,
    String model,
    Double temperature,
    Integer maxTokens
) {
}
