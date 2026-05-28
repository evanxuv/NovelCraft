package com.novelcraft;

import com.novelcraft.config.AiProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(AiProperties.class)
public class NovelCraftApplication {

    public static void main(String[] args) {
        SpringApplication.run(NovelCraftApplication.class, args);
    }
}
