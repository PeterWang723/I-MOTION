package com.peter.imotion.infer.general_entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class Purpose {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String activity;
}
