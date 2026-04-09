package com.dataservice.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

/* Domain Transaction Object Class */

@Entity
@Table(name = "data")
public class Data {

    @Id
    @GeneratedValue()
    private long id;

    @Column(nullable = false)
    @NotBlank(message = "Name cannot be blank")
    private String name;

    @Column()
    private String description;

    public Data() {
    }

    public Data(long id, String name, String description) {
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

    @Override
    public String toString() {
        return "Data{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
