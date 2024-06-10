package com.peter.wang.imotion.datacollection.general_entity;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
public class Location {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long uid;
    private Date created_time;
    private Double latitude;
    private Double longitude;
}
