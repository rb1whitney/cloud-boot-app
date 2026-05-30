package com.dataservice.test;

import org.junit.jupiter.api.Test;
import org.springframework.boot.SpringBootVersion;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class ProjectVersionTest {

    @Test
    public void testSpringBootVersion() {
        String version = SpringBootVersion.getVersion();
        System.out.println("Current Spring Boot Version: " + version);
        assertTrue(version.startsWith("3.2"), "Spring Boot version should be 3.2.x");
    }

    @Test
    public void testJavaVersion() {
        String version = System.getProperty("java.version");
        System.out.println("Current Java Version: " + version);
        assertTrue(version.startsWith("21") || version.startsWith("25"), "Java version should be 21 or 25");
    }
}
