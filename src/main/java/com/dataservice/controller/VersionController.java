package com.dataservice.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Presents a basic mapping for a Version and Welcome Page for testing purposes.
 */
@Controller
public class VersionController {
    // Read values from application.yml to expose values to JSP. These values are ultimately put in via Maven Filter
    // Resource. Defaults are set to Unknown
    @Value("${project.artifactId:UNKNOWN}")
    private String artifactId = "UNKNOWN";

    @Value("${project.version:UNKNOWN}")
    private String version = "UNKNOWN";

    @Value("${project.maintainer:UNKNOWN}")
    private String maintainer = "UNKNOWN";

    @Value("${server.environment_name:UNKNOWN}")
    private String environment_name = "UNKNOWN";

    // Returns a Version Servlet
    @RequestMapping(value = "/version", method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    @ResponseBody
    public String getVersion() {
        // Uses String Builder to build response string once.
        StringBuilder response = new StringBuilder();
        response.append("<html><head><title>Application Version</title></head><body>");
        response.append(artifactId);
        response.append(".");
        response.append(version);
        response.append("</body></html>");
        return response.toString();
    }

    // Default welcome page for testing purposes
    @RequestMapping(value = "/welcome", method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    @ResponseBody
    public String getWelcomePage() {
        // Uses String Builder to build response string once.
        StringBuilder response = new StringBuilder();
        response.append("<html><head><title>");
        response.append(artifactId);
        response.append("</title></head><body><b>Welcome to this Demo App!!!</b></br>Mantained by:");
        response.append(maintainer);
        response.append("<br>Environment Name:");
        response.append(environment_name);
        response.append("</body></html>");
        return response.toString();
    }
}