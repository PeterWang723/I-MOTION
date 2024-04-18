package com.peter.imotion.dao;

import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
public class Log {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "uid", nullable=false)
    private Users users;

    @Temporal(TemporalType.TIMESTAMP)
    private Date time;

    private String message;
}
