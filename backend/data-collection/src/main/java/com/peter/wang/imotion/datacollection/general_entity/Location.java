package com.peter.wang.imotion.datacollection.general_entity;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
public class Location {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private long uid;
    private Date time;
    private double latitude;
    private boolean longitude;
}
