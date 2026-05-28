package com.novelcraft.generation.controller;

import com.novelcraft.generation.application.AiGateway;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.Instant;
import java.util.Map;

@RestController
@RequestMapping("/api/generation")
public class GenerationController {

    private final AiGateway aiGateway;

    public GenerationController(AiGateway aiGateway) {
        this.aiGateway = aiGateway;
    }

    @GetMapping(path = "/demo/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    SseEmitter streamDemo() throws IOException {
        SseEmitter emitter = new SseEmitter(30_000L);
        emitter.send(SseEmitter.event()
            .name("metadata")
            .data(Map.of("taskId", "demo", "time", Instant.now().toString())));

        for (String chunk : aiGateway.streamDemo()) {
            emitter.send(SseEmitter.event()
                .name("delta")
                .data(Map.of("text", chunk)));
        }

        emitter.send(SseEmitter.event()
            .name("completed")
            .data(Map.of("taskId", "demo")));
        emitter.complete();
        return emitter;
    }
}
