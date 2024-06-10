package com.peter.wang.imotion.auth.controller;

import com.peter.wang.imotion.auth.data.Privacy;
import com.peter.wang.imotion.auth.data.Role;
import com.peter.wang.imotion.auth.feign.UserClient;
import com.peter.wang.imotion.auth.model.LoginEntity;
import com.peter.wang.imotion.auth.model.Response;
import com.peter.wang.imotion.auth.model.ReturnCode;
import com.peter.wang.imotion.auth.model.Users;
import com.peter.wang.imotion.auth.service.EmailService;
import com.peter.wang.imotion.auth.utils.EmailUtils;
import com.peter.wang.imotion.auth.utils.JWTUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Random;

@RestController
@RequestMapping(path = "/auth")
@Slf4j
public class AuthController {

    @Autowired
    JWTUtils jwtUtils;


    @Autowired
    EmailUtils emailUtils;

    @Autowired
    UserClient userClient;

    @PostMapping("/login")
    public Response<String> login(@RequestBody LoginEntity user) {

        // 获取用户信息、比对密码, 用 feign
        Response<String> response = userClient.getUser(user);
        if(ReturnCode.SUCCESS.getCode() != response.getStatus()){
            log.error(response.getMessage());
            return response;
        }
        String token = jwtUtils.createJwt(response.getData());
        return new Response<>(ReturnCode.SUCCESS, token);
    }

    @PostMapping("/register")
    public Response<String> register(@Valid @RequestBody LoginEntity user) {
        Users r_user = new Users();
        r_user.setUsername(user.getUsername());
        r_user.setPassword(user.getPassword());
        r_user.setRole(Role.USER);
        r_user.setPrivacyLevel(Privacy.LOW);
        r_user.setExpired(false);
        r_user.setHouseHold("No");
        r_user.setBlocked(false);
        Response<String> response = userClient.registerUser(r_user);
        if(ReturnCode.SUCCESS.getCode() != response.getStatus()){
            log.error(response.getMessage());
            return response;
        }
        Random rand = new Random();
        StringBuilder verificationCode = new StringBuilder();

        for (int i = 0; i < 10; i++) {
            int digit = rand.nextInt(10);
            verificationCode.append(digit);
        }

        String subject = "IMOTION Email Verification";
        String text = "This is your verification code: " + verificationCode;

        // emailService.sendEmail(loginDto.getUsername(), subject, text);

        return new Response<>(ReturnCode.SUCCESS);
    }

    @GetMapping("/verify")
    public String verifyEmail(@RequestParam String code) {
        // 根据验证代码处理验证逻辑，例如更新用户的验证状态
        boolean isVerified = emailUtils.verifyUserEmail(code);
        return isVerified ? "Email verified successfully!" : "Invalid verification code!";
    }

    @PostMapping("/delete")
    public Response<String> delete(HttpServletRequest request, @Valid @RequestBody LoginEntity user) {

        Response<String> response = new Response<>(ReturnCode.SUCCESS);
        if(ReturnCode.SUCCESS.getCode() != response.getStatus()){
            log.error(response.getMessage());
            return response;
        }
        String token = jwtUtils.createJwt(user.getUsername());
        return new Response<>(ReturnCode.SUCCESS, token);
    }

}
