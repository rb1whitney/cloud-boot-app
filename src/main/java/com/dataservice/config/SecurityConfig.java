package com.dataservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/manage/health", "/manage/info").permitAll() // Only allow baseline indicators
                .requestMatchers("/manage/**").authenticated() // Require auth for sensitive actuators (env, beans, etc)
                .requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/cloud-boot-app/swagger-ui/**", "/cloud-boot-app/v3/api-docs/**").permitAll()
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults()); // Use basic auth for simplicity in this step
        return http.build();
    }
}
