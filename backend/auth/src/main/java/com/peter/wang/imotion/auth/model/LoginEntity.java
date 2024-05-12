package com.peter.wang.imotion.auth.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@AllArgsConstructor
@RequiredArgsConstructor
public class LoginEntity {
    private String username;
    private String password;
}
