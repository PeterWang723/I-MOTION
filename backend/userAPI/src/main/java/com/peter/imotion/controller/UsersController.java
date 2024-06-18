package com.peter.imotion.controller;

import com.peter.imotion.dao.general_entity.Response;
import com.peter.imotion.dao.general_entity.ReturnCode;
import com.peter.imotion.dao.general_entity.Users;
import com.peter.imotion.data.Role;
import com.peter.imotion.repository.UsersRepository;
import com.peter.imotion.service.RegistrationService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping(path = "/user")
@Slf4j
public class UsersController {
    @Autowired
    private UsersRepository usersRepository;

    @PostMapping("/login")
    public Response<String> logIn(@RequestBody Users user) {
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
        user.setRole(Role.USER);
        usersRepository.save(user);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/delete")
    public Response<String> delete(@RequestBody Users user) {
        if(usersRepository.existsById(user.getId())) {
            usersRepository.deleteById(user.getId());
            return new Response<>(ReturnCode.SUCCESS);
        }
        return new Response<>(ReturnCode.USER_NOT_EXIST);
    }

    @PutMapping("/set_privacy")
    public Response<String> setPrivacy(@RequestBody Users user) {
        System.out.println(user);
        if(usersRepository.existsById(user.getId())) {
            usersRepository.setPrivacyById(user.getId(), user.getPrivacyLevel());
            return new Response<>(ReturnCode.SUCCESS);
        }
        return new Response<>(ReturnCode.USER_NOT_EXIST);
    }
}
