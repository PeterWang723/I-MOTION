package com.peter.imotion.controller;

import com.peter.imotion.dao.general_entity.Users;
import com.peter.imotion.repository.UsersRepository;
import com.peter.imotion.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "/user/v1/")
public class UsersController {
    @Autowired
    private RegistrationService registrationService;

    @PostMapping("/login")
    public ResponseEntity<String> logIn(@RequestBody Users user, @RequestHeader("Authorization") String token) {
        return ResponseEntity
                .ok()
                .body("null");
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody Users user) {
        String result = registrationService.register(user);
        return ResponseEntity
                .ok()
                .body("result");
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout() {
        return ResponseEntity
                .ok()
                .body("null");
    }
}
