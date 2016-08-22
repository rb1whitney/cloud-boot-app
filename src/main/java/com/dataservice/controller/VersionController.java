package com.dataservice.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Map;

/**
 * Presents a basic mapping for a Version Servlet JSP
 */
@Controller
@RequestMapping("/version")
public class VersionController {
    //Read values from Application.yml to expose values to JSP
    @Value("${info.build.name:Unable to find app name}")
    private String app_name = "Unable to find app name";

    @Value("${info.build.artifactId:UNKNOWN}")
    private String artifactId = "UNKNOWN";

    @Value("${info.build.version:UNKNOWN}")
    private String version = "UNKNOWN";

    @RequestMapping(value = "",
            method = RequestMethod.GET)
    public String version(Map<String, Object> model) {
        model.put("app_name", this.app_name);
        model.put("artifactId", this.artifactId);
        model.put("version", this.version);
        return "version";
    }
}