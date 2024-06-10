package com.peter.wang.imotion.auth.model;

import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@AllArgsConstructor
@RequiredArgsConstructor
public class LoginEntity {
    @Email
    private String username;
    private String password;
}
