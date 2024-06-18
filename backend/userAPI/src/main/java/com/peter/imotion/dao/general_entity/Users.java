package com.peter.imotion.dao.general_entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.peter.imotion.data.Privacy;
import com.peter.imotion.data.Role;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Collection;
import java.util.List;

@Entity
@Data
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String username;
    private String password;
    private boolean isExpired;
    private boolean isBlocked;
    private String houseHold;

    @Enumerated(EnumType.STRING)
    private Privacy privacyLevel;

    @Enumerated(EnumType.STRING)
    private Role role;
}
