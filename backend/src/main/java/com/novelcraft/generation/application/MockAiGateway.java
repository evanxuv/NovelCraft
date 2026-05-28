package com.novelcraft.generation.application;

import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class MockAiGateway implements AiGateway {

    @Override
    public List<String> streamDemo() {
        return List.of("NovelCraft ", "AI ", "stream ready.");
    }
}
