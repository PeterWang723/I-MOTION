package com.peter.imotion.infer.general_entity;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
public class Activity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private long u_id;
    private String mode;

    @Temporal(TemporalType.TIMESTAMP)
    private Date day;

    @Temporal(TemporalType.TIMESTAMP)
    private Date start_time;

    @Temporal(TemporalType.TIMESTAMP)
    private Date end_time;

    private String origin;
    private String destination;
    private String activities;
    private Integer cost;
    private Integer luggage_num;
    private Integer luggage_type;
    private Integer luggage_weight;
    private Integer travel_car_cost;
}
