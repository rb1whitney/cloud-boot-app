package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import com.dataservice.dto.DataDTO;
import com.dataservice.exception.ResourceNotFoundException;
import com.dataservice.service.DataService;
import com.fasterxml.jackson.databind.ObjectMapper;
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

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = DataServiceSpringController.class)
@AutoConfigureMockMvc
public class DataControllerErrorTest {

    @Autowired
    private MockMvc mvc;

    @MockBean
    private DataService dataService;

    @Test
    @WithMockUser
    public void shouldReturnNotFoundWhenGettingNonExistentResource() throws Exception {
        when(dataService.getData(anyLong())).thenReturn(null);

        mvc.perform(get("/api/v1/data/999")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @WithMockUser
    public void shouldReturnNotFoundWhenUpdatingNonExistentResource() throws Exception {
        when(dataService.getData(anyLong())).thenReturn(null);
        DataDTO updateData = new DataDTO(999L, "Update", "Description");

        mvc.perform(put("/api/v1/data/999")
                .content(new ObjectMapper().writeValueAsBytes(updateData))
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @WithMockUser
    public void shouldReturnNotFoundWhenDeletingNonExistentResource() throws Exception {
        when(dataService.getData(anyLong())).thenReturn(null);

        mvc.perform(delete("/api/v1/data/999")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @WithMockUser
    public void shouldReturnNotFoundWhenIdsMismatchOnUpdate() throws Exception {
        DataDTO existingData = new DataDTO(1L, "Existing", "Description");
        when(dataService.getData(1L)).thenReturn(existingData);
        
        // Payload has ID 2, but URL has ID 1
        DataDTO mismatchData = new DataDTO(2L, "Mismatch", "Description");

        mvc.perform(put("/api/v1/data/1")
                .content(new ObjectMapper().writeValueAsBytes(mismatchData))
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }
    
    @Test
    public void shouldReturnUnauthorizedWhenAccessingWithoutUser() throws Exception {
        // No @WithMockUser
        mvc.perform(get("/api/v1/data")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized());
    }
}
