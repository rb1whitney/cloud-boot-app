package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import com.dataservice.controller.DataController;
import com.dataservice.dto.DataDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultMatcher;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.regex.Pattern;

import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = DataServiceSpringController.class)
public class DataServiceControllerTest {

    private static final String RESOURCE_LOCATION_PATTERN = "http://localhost/api/v1/data/[0-9]+";

    @InjectMocks
    DataController controller;

    @Autowired
    WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    public void initTests() {
        MockitoAnnotations.initMocks(this);
        mvc = MockMvcBuilders.webAppContextSetup(context)
                .apply(springSecurity())
                .build();
    }

    @Test
    @WithMockUser
    public void shouldHaveOKStatus() throws Exception {
        mvc.perform(get("/api/v1/data")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    @WithMockUser
    public void shouldGetPaginatedData() throws Exception {
        mvc.perform(get("/api/v1/data?page=0&size=5")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    @WithMockUser
    public void shouldCreateReadDelete() throws Exception {
        DataDTO mockData = mockData("shouldCreateRetrieveDelete");
        byte[] dataJson = toJson(mockData);
        
        MvcResult result = mvc.perform(post("/api/v1/data")
                .content(dataJson)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andExpect(redirectedUrlPattern(RESOURCE_LOCATION_PATTERN))
                .andReturn();
        long id = getResourceIdFromUrl(result.getResponse().getHeader("Location"));

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
    @WithMockUser
    public void shouldCreateAndUpdateAndDelete() throws Exception {
        DataDTO mockData = mockData("shouldCreateAndUpdate");
        byte[] dataJson = toJson(mockData);

        MvcResult result = mvc.perform(post("/api/v1/data")
                .content(dataJson)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andExpect(redirectedUrlPattern(RESOURCE_LOCATION_PATTERN))
                .andReturn();
        long id = getResourceIdFromUrl(result.getResponse().getHeader("Location"));

        DataDTO updateMockData = mockData("shouldCreateAndUpdate2");
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

    private DataDTO mockData(String prefix) {
        DataDTO r = new DataDTO();
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
