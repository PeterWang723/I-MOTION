package com.peter.imotion.dao.general_entity;

import com.peter.imotion.data.Privacy;
import com.peter.imotion.data.Role;
import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

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
