package com.dataservice.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.xml.bind.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/* Domain Transaction Object Class */

@Entity
@Table(name = "data")
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Data {

    @Id
    @GeneratedValue()
    private long id;

    @Column(nullable = false)
    @NotBlank(message = "Name cannot be blank")
    private String name;

    @Column()
    private String description;
}
