package com.peter.imotion.dao.raw_data;


import com.peter.imotion.dao.general_entity.Users;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
public class Health {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "uid", nullable=false)
    private Users users;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    private int heartRate;

    private Double bloodOxygen;
}
