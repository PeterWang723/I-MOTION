package com.peter.imotion.controller;

import com.peter.imotion.dao.general_entity.Response;
import com.peter.imotion.dao.general_entity.ReturnCode;
import com.peter.imotion.dao.general_entity.Users;
import com.peter.imotion.repository.UsersRepository;
import com.peter.imotion.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping(path = "/user")
public class UsersController {
    @Autowired
    private UsersRepository usersRepository;

    @PostMapping("/login")
    public Response<String> logIn(@RequestBody Users user) {
        System.out.println(user);
        if (usersRepository.existsByUsernameAndPassword(user.getUsername(), user.getPassword())) {
            Users get_user = usersRepository.findByUsername(user.getUsername());
            long userId = get_user.getId();
            return new Response<>(ReturnCode.SUCCESS, Long.toString(userId));
        } else {
            return new Response<>(ReturnCode.INVALID_USER_LOGIN);
        }
    }

    @PostMapping("/register")
    public Response<String> register(@RequestBody Users user) {
        if(usersRepository.existsByUsername(user.getUsername())) {
            return new Response<>(ReturnCode.USER_ALREADY_EXISTS);
        }
        usersRepository.save(user);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/delete")
    public Response<String> delete(@RequestBody Users user) {
        usersRepository.deleteByUsername(user.getUsername());
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/set_privacy")
    public Response<String> setPrivacy() {
        return new Response<>(ReturnCode.SUCCESS);
    }
}
