package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import com.dataservice.domain.Data;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = DataServiceSpringController.class)
@AutoConfigureMockMvc
public class DataValidationTest {

    @Autowired
    private MockMvc mvc;

    @Test
    @WithMockUser
    public void shouldFailWhenNameIsNull() throws Exception {
        Data mockData = new Data();
        mockData.setDescription("description without name");
        // name is null, should fail validation if Bean Validation is active
        
        byte[] dataJson = new ObjectMapper().writeValueAsBytes(mockData);

        mvc.perform(post("/api/v1/data")
                .content(dataJson)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest());
    }

    @Test
    @WithMockUser
    public void exerciseAllDataMethods() {
        Data data = new Data();
        data.setId(100L);
        data.setName("Test Name");
        data.setDescription("Test Description");
        
        assert(data.getId() == 100L);
        assert(data.getName().equals("Test Name"));
        assert(data.getDescription().equals("Test Description"));
    }
}
