package com.peter.wang.imotion.datacollection.general_entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

import java.util.Date;

@Entity
@Data
public class CarEnergyUsage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long uid;
    private Date from_time;
    private Date to_time;
    private Double energyUsage;

}
