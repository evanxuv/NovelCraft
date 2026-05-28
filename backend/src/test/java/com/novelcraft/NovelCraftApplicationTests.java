package com.novelcraft;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = {
    "spring.flyway.enabled=false",
    "spring.ai.openai-sdk.api-key=test-key"
})
class NovelCraftApplicationTests {

    @Test
    void contextLoads() {
    }
}
