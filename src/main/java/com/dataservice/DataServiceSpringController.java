package com.dataservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/* Spring Auto Boot Class */
@SpringBootApplication
@EnableJpaRepositories("com.dataservice.repository")
public class DataServiceSpringController extends SpringBootServletInitializer {

    private static final Logger log = LoggerFactory.getLogger(DataServiceSpringController.class);

	public static void main(String[] args) {
        SpringApplication.run(DataServiceSpringController.class, args);
	}

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        log.info("Configuring application with Spring Boot");
        return application.sources(DataServiceSpringController.class);
    }
}
