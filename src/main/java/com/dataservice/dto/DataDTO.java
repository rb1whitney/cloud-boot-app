package com.dataservice.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

/* Data Transfer Object to decouple API from Persistence Entity */

@Schema(description = "Data Transfer Object for sharing data information")
public class DataDTO {
    @Schema(description = "The unique identifier of the data", example = "1")
    private long id;

    @Schema(description = "The name of the data", example = "Sample Data")
    @NotBlank(message = "Name cannot be blank")
    private String name;

    @Schema(description = "The description of the data", example = "A detailed description of the data")
    private String description;

    public DataDTO() {
    }

    public DataDTO(long id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
