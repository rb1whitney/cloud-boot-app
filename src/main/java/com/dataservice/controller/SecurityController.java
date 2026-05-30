package com.dataservice.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/security")
@Tag(name = "Security", description = "The Security API")
public class SecurityController {

    // SSRF Prevention: Only allow specific domains for SSL checking
    private static final List<String> ALLOWED_DOMAINS = List.of("rwhitney.com", "example.com", "google.com");

    @Operation(summary = "Perform SSL check", description = "Mimics SSL Labs integration results for a given target")
    @GetMapping(value = "/ssl-check", produces = "application/json")
    @ResponseStatus(HttpStatus.OK)
    public @ResponseBody Map<String, Object> sslCheck(
            @Parameter(description = "Hostname or URL to check") @RequestParam("target") String target) {
        
        if (target == null || ALLOWED_DOMAINS.stream().noneMatch(target::endsWith)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Target domain not allowed");
        }

        Map<String, Object> response = new HashMap<>();
        response.put("target", target);
        response.put("status", "READY");
        response.put("grade", "A+");
        
        Map<String, Object> details = new HashMap<>();
        details.put("certExpiry", "2026-12-31");
        details.put("protocols", new String[]{"TLS 1.2", "TLS 1.3"});
        details.put("vulnerabilities", new String[]{});
        
        response.put("details", details);
        
        return response;
    }
}
