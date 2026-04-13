package com.dataservice.dto;

import jakarta.validation.constraints.NotBlank;

/* Data Transfer Object to decouple API from Persistence Entity */

public class DataDTO {
    private long id;

    @NotBlank(message = "Name cannot be blank")
    private String name;

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
