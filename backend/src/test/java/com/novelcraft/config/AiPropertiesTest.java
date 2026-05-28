package com.novelcraft.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.context.annotation.Configuration;

import static org.assertj.core.api.Assertions.assertThat;

class AiPropertiesTest {

    private final ApplicationContextRunner contextRunner = new ApplicationContextRunner()
        .withUserConfiguration(TestConfig.class)
        .withPropertyValues(
            "novelcraft.ai.provider=openai-compatible",
            "novelcraft.ai.model=test-model",
            "novelcraft.ai.temperature=0.7",
            "novelcraft.ai.max-tokens=2048"
        );

    @Test
    void bindsAiProperties() {
        contextRunner.run(context -> {
            AiProperties properties = context.getBean(AiProperties.class);

            assertThat(properties.provider()).isEqualTo("openai-compatible");
            assertThat(properties.model()).isEqualTo("test-model");
            assertThat(properties.temperature()).isEqualTo(0.7);
            assertThat(properties.maxTokens()).isEqualTo(2048);
        });
    }

    @Configuration
    @EnableConfigurationProperties(AiProperties.class)
    static class TestConfig {
    }
}
