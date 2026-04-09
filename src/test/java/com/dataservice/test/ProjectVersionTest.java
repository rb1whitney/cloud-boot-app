package com.dataservice.test;

import org.junit.Test;
import org.springframework.boot.SpringBootVersion;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;

public class ProjectVersionTest {

    @Test
    public void testSpringBootVersion() {
        String version = SpringBootVersion.getVersion();
        System.out.println("Current Spring Boot Version: " + version);
        assertTrue("Spring Boot version should be 3.2.x", version.startsWith("3.2"));
    }

    @Test
    public void testJavaVersion() {
        String version = System.getProperty("java.version");
        System.out.println("Current Java Version: " + version);
        assertTrue("Java version should be 21", version.startsWith("21"));
    }
}
