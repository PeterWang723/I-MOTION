package com.peter.wang.imotion.auth.controller;

import com.peter.wang.imotion.auth.feign.UserClient;
import com.peter.wang.imotion.auth.model.LoginEntity;
import com.peter.wang.imotion.auth.model.Response;
import com.peter.wang.imotion.auth.model.ReturnCode;
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
@RequestMapping(path = "/auth/v1/")
@Slf4j
public class AuthController {

    @Autowired
    JWTUtils jwtUtils;


    @Autowired
    EmailUtils emailUtils;

    @Autowired
    UserClient userClient;

    @GetMapping("/test")
    public String test(@RequestParam String code) {
        log.info("Auth got a code");
        return "You got a" + code;
    }

    @PostMapping("/login")
    public Response<String> login(@Valid @RequestBody LoginEntity user) {

        // 获取用户信息、比对密码, 用 feign
        Response<String> response = userClient.getUser(user.getUsername(), user.getPassword());
        if(ReturnCode.SUCCESS.getCode() != response.getStatus()){
            log.error(response.getMessage());
            return response;
        }
        String token = jwtUtils.createJwt(user.getUsername());
        return new Response<>(ReturnCode.SUCCESS, token);
    }

    @PostMapping("/register")
    public Response<String> register(HttpServletRequest request, @Valid @RequestBody LoginEntity loginDto) {

        Response<String> response = new Response<>(ReturnCode.SUCCESS);
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
