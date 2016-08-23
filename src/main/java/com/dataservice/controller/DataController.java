package com.dataservice.controller;

import com.dataservice.domain.Data;
import com.dataservice.exception.ResourceNotFoundException;
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

    // This function creates data if it is not there. If it is there, it will overwrite it. Location will be returned
    // back to user.
    @RequestMapping(value = "",
            method = RequestMethod.POST,
            consumes = {"application/json", "application/xml"},
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.CREATED)
    public void createData(@RequestBody Data data, HttpServletRequest request, HttpServletResponse response) {
        Data createdData = this.dataService.createData(data);
        logger.debug("Created following data: " + createdData);
        response.setHeader("Location", request.getRequestURL().append("/").append(createdData.getId()).toString());
    }

    // Gets all data that is available to the Data Service
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

    // Gets data via the resource id
    @RequestMapping(value = "/{id}",
            method = RequestMethod.GET,
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.OK)
    public
    @ResponseBody
    Data getData(@PathVariable("id") Long id, HttpServletRequest request, HttpServletResponse response)
            throws ResourceNotFoundException {
        Data data = this.dataService.getData(id);
        checkResourceFound(data);
        return data;
    }

    // Updates data via resource id. Note that id is required in json or otherwise resource will not be found.
    @RequestMapping(value = "/{id}",
            method = RequestMethod.PUT,
            consumes = {"application/json", "application/xml"},
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void updateData(@PathVariable("id") Long id, @RequestBody Data data,
                           HttpServletRequest request, HttpServletResponse response) throws ResourceNotFoundException {
        checkResourceFound(this.dataService.getData(id));
        if (id != data.getId()) throw new ResourceNotFoundException();
        this.dataService.updateData(data);
        logger.debug("Updated the following data: " + data);
    }

    // Deletes data via resource id
    @RequestMapping(value = "/{id}",
            method = RequestMethod.DELETE,
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteData(@PathVariable("id") Long id, HttpServletRequest request,
                           HttpServletResponse response) throws ResourceNotFoundException {
        checkResourceFound(this.dataService.getData(id));
        this.dataService.deleteData(id);
        logger.debug("Deleted the following data associated with id: " + id);
    }

    // Checks if resource was found from Data Service. Otherwise, will return basic exception
    private static <T> T checkResourceFound(final T resource) throws ResourceNotFoundException {
        if (resource == null) {
            throw new ResourceNotFoundException();
        }
        return resource;
    }
}
