package com.peter.imotion.infer.general_entity;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Entity
@Data
public class Activity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private long u_id;
    private String mode;

    private Date day;

    private Date start_time;

    private Date end_time;

    private String origin;
    private String destination;
    private Integer cost;
    private Integer luggage_num;
    private Integer luggage_type;
    private Integer luggage_weight;
    private Integer travel_car_cost;

    @OneToMany(mappedBy = "activity", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Purpose> purposes;
}
