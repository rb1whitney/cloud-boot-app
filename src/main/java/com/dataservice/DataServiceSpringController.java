package com.dataservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/* Spring Auto Boot Class */
@SpringBootApplication
@Configuration
@EnableAutoConfiguration
@ComponentScan(basePackages = "com.dataservice")
@EnableJpaRepositories("com.dataservice.repository")
public class DataServiceSpringController extends SpringBootServletInitializer {

    private static final Logger logger = LoggerFactory.getLogger(DataServiceSpringController.class);

	public static void main(String[] args) {
        SpringApplication.run(DataServiceSpringController.class, args);
	}

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        logger.info("Configuring application with Spring Boot");
        return application.sources(DataServiceSpringController.class);
    }
}
