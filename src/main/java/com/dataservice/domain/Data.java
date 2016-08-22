package com.dataservice.domain;

import javax.persistence.*;
import javax.xml.bind.annotation.*;

/* Domain Transaction Object Class */

@Entity
@Table(name = "data")
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class Data {

    @Id
    @GeneratedValue()
    private long id;

    @Column(nullable = false)
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

    @java.lang.Override
    public java.lang.String toString() {
        return "Data{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
