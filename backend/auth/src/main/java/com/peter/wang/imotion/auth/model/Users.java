package com.peter.wang.imotion.auth.model;

import com.peter.wang.imotion.auth.data.Privacy;
import com.peter.wang.imotion.auth.data.Role;
import lombok.Data;

@Data
public class Users {
    private long id;
    private String username;
    private String password;
    private boolean isExpired;
    private boolean isBlocked;
    private String houseHold;
    private Privacy privacyLevel;
    private Role role;
}