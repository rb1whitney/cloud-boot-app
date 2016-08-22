package com.dataservice.controller;

import com.dataservice.domain.Data;
import com.dataservice.service.DataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/* REST API endpoints */

@RestController
@RequestMapping(value = "/api/v1/data")
public class DataController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private static final String DEFAULT_PAGE_SIZE = "10";
    private static final String DEFAULT_PAGE_NUM = "0";

    @Autowired
    private DataService dataService;

    @RequestMapping(value = "",
            method = RequestMethod.POST,
            consumes = {"application/json", "application/xml"},
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.CREATED)
    public void createData(@RequestBody Data data, HttpServletRequest request, HttpServletResponse response) {
        Data createdData = this.dataService.createData(data);
        response.setHeader("Location", request.getRequestURL().append("/").append(createdData.getId()).toString());
    }

    @RequestMapping(value = "",
            method = RequestMethod.GET,
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.OK)
    public
    @ResponseBody
    Page<Data> getAllData(@RequestParam(value = "page", required = true, defaultValue = DEFAULT_PAGE_NUM) Integer page,
                          @RequestParam(value = "size", required = true, defaultValue = DEFAULT_PAGE_SIZE) Integer size,
                          HttpServletRequest request, HttpServletResponse response) {
        return this.dataService.getAllData(page, size);
    }

    @RequestMapping(value = "/{id}",
            method = RequestMethod.GET,
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.OK)
    public
    @ResponseBody
    Data getData(@PathVariable("id") Long id, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Data data = this.dataService.getData(id);
        checkResourceFound(data);
        return data;
    }

    @RequestMapping(value = "/{id}",
            method = RequestMethod.PUT,
            consumes = {"application/json", "application/xml"},
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void updateData(@PathVariable("id") Long id, @RequestBody Data data,
                           HttpServletRequest request, HttpServletResponse response) throws Exception {
        checkResourceFound(this.dataService.getData(id));
        if (id != data.getId()) throw new Exception("ID doesn't match!");
        this.dataService.updateData(data);
    }

    @RequestMapping(value = "/{id}",
            method = RequestMethod.DELETE,
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteData(@PathVariable("id") Long id, HttpServletRequest request,
                           HttpServletResponse response) throws Exception {
        checkResourceFound(this.dataService.getData(id));
        this.dataService.deleteData(id);
    }

    private static <T> T checkResourceFound(final T resource) throws Exception {
        if (resource == null) {
            throw new Exception("data object not found");
        }
        return resource;
    }
}
