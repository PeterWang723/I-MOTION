package com.peter.imotion.controller;

import com.peter.imotion.dao.general_entity.Response;
import com.peter.imotion.dao.general_entity.ReturnCode;
import com.peter.imotion.dao.general_entity.Users;
import com.peter.imotion.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "/user/v1/")
public class UsersController {
    @Autowired
    private RegistrationService registrationService;

    @PostMapping("/login")
    public Response<String> logIn(@RequestBody Users user, @RequestHeader("Authorization") String token) {

        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/register")
    public Response<String> register(@RequestBody Users user) {
        String result = registrationService.register(user);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/delete")
    public Response<String> delete() {
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/set_privacy")
    public Response<String> setPrivacy() {
        return new Response<>(ReturnCode.SUCCESS);
    }
}
