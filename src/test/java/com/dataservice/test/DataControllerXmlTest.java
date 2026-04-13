package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import com.dataservice.dto.DataDTO;
import com.dataservice.service.DataService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.xpath;

@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = DataServiceSpringController.class)
@AutoConfigureMockMvc
public class DataControllerXmlTest {

    @Autowired
    private MockMvc mvc;

    @MockBean
    private DataService dataService;

    @Test
    @WithMockUser
    public void shouldCreateAndReadXml() throws Exception {
        DataDTO mockData = new DataDTO(1L, "XML Name", "XML Description");
        when(dataService.createData(any())).thenReturn(mockData);
        when(dataService.getData(1L)).thenReturn(mockData);

        // Simple XML string for DTO
        String xml = "<DataDTO><id>1</id><name>XML Name</name><description>XML Description</description></DataDTO>";

        mvc.perform(post("/api/v1/data")
                .content(xml)
                .contentType(MediaType.APPLICATION_XML)
                .accept(MediaType.APPLICATION_XML))
                .andExpect(status().isCreated());

        mvc.perform(get("/api/v1/data/1")
                .accept(MediaType.APPLICATION_XML))
                .andExpect(status().isOk())
                .andExpect(xpath("/DataDTO/name").string("XML Name"))
                .andExpect(xpath("/DataDTO/description").string("XML Description"));
    }
}
