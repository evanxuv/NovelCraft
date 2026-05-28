package com.novelcraft.health;

import com.novelcraft.common.api.ApiResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    @GetMapping
    ApiResponse<HealthStatus> health() {
        return ApiResponse.ok(new HealthStatus("UP", "novelcraft-backend"));
    }

    record HealthStatus(String status, String service) {
    }
}
