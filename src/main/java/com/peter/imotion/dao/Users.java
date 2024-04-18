package com.peter.imotion.dao;

import com.peter.imotion.data.Privacy;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Data
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @OneToMany(mappedBy = "users")
    private List<Log> logs;

    private String username;
    private String password;
    private boolean isExpired;
    private boolean isBlocked;
    private String houseHold;

    @Enumerated(EnumType.STRING)
    private Privacy privacyLevel;
}
