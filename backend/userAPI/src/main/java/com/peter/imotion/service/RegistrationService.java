package com.peter.imotion.service;

import com.peter.imotion.dao.general_entity.Users;
import org.springframework.stereotype.Service;

@Service
public class RegistrationService {
    public String register(Users user) {
        return "ok";
    }
}
