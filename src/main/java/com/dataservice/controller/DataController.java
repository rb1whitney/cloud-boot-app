package com.dataservice.controller;

import com.dataservice.dto.DataDTO;
import com.dataservice.exception.ResourceNotFoundException;
import com.dataservice.service.DataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;

/* REST API endpoints */

@RestController
@RequestMapping(value = "/api/v1/data")
public class DataController {

    private static final Logger log = LoggerFactory.getLogger(DataController.class);
    private static final String DEFAULT_PAGE_SIZE = "10";
    private static final String DEFAULT_PAGE_NUM = "0";

    @Autowired
    private DataService dataService;

    // This function creates data if it is not there. If it is there, it will overwrite it. Location will be returned
    // back to user.
    @PostMapping(value = "",
            consumes = {"application/json", "application/xml"},
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.CREATED)
    public void createData(@RequestBody @Valid DataDTO data, HttpServletRequest request, HttpServletResponse response) {
        DataDTO createdData = this.dataService.createData(data);
        log.debug("Created following data: {}", createdData);
        response.setHeader("Location", request.getRequestURL().append("/").append(createdData.getId()).toString());
    }

    // Gets all data that is available to the Data Service
    @GetMapping(value = "",
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.OK)
    public @ResponseBody Page<DataDTO> getAllData(@RequestParam(value = "page", defaultValue = DEFAULT_PAGE_NUM) Integer page,
                                               @RequestParam(value = "size", defaultValue = DEFAULT_PAGE_SIZE) Integer size,
                                               HttpServletRequest request, HttpServletResponse response) {
        return this.dataService.getAllData(page, size);
    }

    // Gets data via the resource id
    @GetMapping(value = "/{id}",
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.OK)
    public @ResponseBody DataDTO getData(@PathVariable("id") Long id, HttpServletRequest request, HttpServletResponse response)
            throws ResourceNotFoundException {
        DataDTO data = this.dataService.getData(id);
        checkResourceFound(data);
        return data;
    }

    // Updates data via resource id. Note that id is required in json or otherwise resource will not be found.
    @PutMapping(value = "/{id}",
            consumes = {"application/json", "application/xml"},
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void updateData(@PathVariable("id") Long id, @RequestBody @Valid DataDTO data,
                           HttpServletRequest request, HttpServletResponse response) throws ResourceNotFoundException {
        checkResourceFound(this.dataService.getData(id));
        if (id != data.getId()) throw new ResourceNotFoundException();
        this.dataService.updateData(data);
        log.debug("Updated the following data: {}", data);
    }

    // Deletes data via resource id
    @DeleteMapping(value = "/{id}",
            produces = {"application/json", "application/xml"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteData(@PathVariable("id") Long id, HttpServletRequest request,
                           HttpServletResponse response) throws ResourceNotFoundException {
        checkResourceFound(this.dataService.getData(id));
        this.dataService.deleteData(id);
        log.debug("Deleted the following data associated with id: {}", id);
    }

    // Checks if resource was found from Data Service. Otherwise, will return basic exception
    private static <T> T checkResourceFound(final T resource) throws ResourceNotFoundException {
        if (resource == null) {
            throw new ResourceNotFoundException();
        }
        return resource;
    }
}
