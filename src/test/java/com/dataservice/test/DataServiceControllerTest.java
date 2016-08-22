package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import com.dataservice.controller.DataController;
import com.dataservice.domain.Data;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.regex.Pattern;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultMatcher;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = DataServiceSpringController.class)
public class DataServiceControllerTest {

    private static final String RESOURCE_LOCATION_PATTERN = "http://localhost/api/v1/data/[0-9]+";

    @InjectMocks
    DataController controller;

    @Autowired
    WebApplicationContext context;

    private MockMvc mvc;

    @Before
    public void initTests() {
        MockitoAnnotations.initMocks(this);
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void shouldHaveEmptyDB() throws Exception {
        mvc.perform(get("/api/v1/data")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.numberOfElements", is(0)));
    }

    @Test
    public void shouldCreateReadDelete() throws Exception {
        Data mockData = mockData("shouldCreateRetrieveDelete");
        byte[] dataJson = toJson(mockData);
        
        MvcResult result = mvc.perform(post("/api/v1/data")
                .content(dataJson)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andExpect(redirectedUrlPattern(RESOURCE_LOCATION_PATTERN))
                .andReturn();
        long id = getResourceIdFromUrl(result.getResponse().getRedirectedUrl());

        mvc.perform(get("/api/v1/data/" + id)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is((int) id)))
                .andExpect(jsonPath("$.name", is(mockData.getName())))
                .andExpect(jsonPath("$.description", is(mockData.getDescription())));

        mvc.perform(delete("/api/v1/data/" + id))
                .andExpect(status().isNoContent());
    }

    @Test
    public void shouldCreateAndUpdateAndDelete() throws Exception {
        Data mockData = mockData("shouldCreateAndUpdate");
        byte[] dataJson = toJson(mockData);

        MvcResult result = mvc.perform(post("/api/v1/data")
                .content(dataJson)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andExpect(redirectedUrlPattern(RESOURCE_LOCATION_PATTERN))
                .andReturn();
        long id = getResourceIdFromUrl(result.getResponse().getRedirectedUrl());

        Data updateMockData = mockData("shouldCreateAndUpdate2");
        updateMockData.setId(id);
        byte[] updateMockDataJson = toJson(updateMockData);

        mvc.perform(put("/api/v1/data/" + id)
                .content(updateMockDataJson)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent())
                .andReturn();

        mvc.perform(get("/api/v1/data/" + id)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is((int) id)))
                .andExpect(jsonPath("$.name", is(updateMockData.getName())))
                .andExpect(jsonPath("$.description", is(updateMockData.getDescription())));
        
        mvc.perform(delete("/api/v1/data/" + id))
                .andExpect(status().isNoContent());
    }

    private long getResourceIdFromUrl(String locationUrl) {
        String[] parts = locationUrl.split("/");
        return Long.valueOf(parts[parts.length - 1]);
    }

    private Data mockData(String prefix) {
        Data r = new Data();
        r.setDescription(prefix + "_description");
        r.setName(prefix + "_name");
        return r;
    }

    private byte[] toJson(Object r) throws Exception {
        ObjectMapper map = new ObjectMapper();
        return map.writeValueAsString(r).getBytes();
    }

    // match redirect header URL (aka Location header)
    private static ResultMatcher redirectedUrlPattern(final String expectedUrlPattern) {
        return new ResultMatcher() {
            public void match(MvcResult result) {
                Pattern pattern = Pattern.compile("\\A" + expectedUrlPattern + "\\z");
                assertTrue(pattern.matcher(result.getResponse().getRedirectedUrl()).find());
            }
        };
    }

}
