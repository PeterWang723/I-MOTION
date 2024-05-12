package com.peter.wang.imotion.auth.controller;

import com.peter.wang.imotion.auth.model.LoginEntity;
import com.peter.wang.imotion.auth.model.Response;
import com.peter.wang.imotion.auth.model.ReturnCode;
import com.peter.wang.imotion.auth.utils.JWTUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "/auth/v1/")
@Slf4j
public class AuthController {

    @Autowired
    JWTUtils jwtUtils;

    @PostMapping("/login")
    public Response<String> login(@Valid @RequestBody LoginEntity user) {

        // 获取用户信息、比对密码, 用 feign
        Response<String> response = new Response<>(ReturnCode.SUCCESS);
        if(ReturnCode.SUCCESS.getCode() != response.getStatus()){
            log.error(response.getMessage());
            return response;
        }
        String token = jwtUtils.createJwt(user.getUsername());
        return new Response<>(ReturnCode.SUCCESS, token);
    }

    @PostMapping("/register")
    public Response<> login(HttpServletRequest request, @Valid @RequestBody LoginEntity loginDto) {

        String ip = IpAddressUtils.getIpAddr(request);
        // 获取用户信息、比对密码
        Result<UserDTO> result = loginFeignApi.login(loginDto,ip);
        if(ResultCode.SUCCESS.getCode()!=result.getCode()){
            log.error(result.getMsg());
            return result;
        }
        UserDTO user = result.getData();
        String token = JWTUtils.createJwt(user.getId() + "");
        data.put("token",token);
        return new Response<>()
    }

    @PostMapping("/logout")
    public Response<> login(HttpServletRequest request, @Valid @RequestBody LoginEntity loginDto) {

        String ip = IpAddressUtils.getIpAddr(request);
        // 获取用户信息、比对密码
        Result<UserDTO> result = loginFeignApi.login(loginDto,ip);
        if(ResultCode.SUCCESS.getCode()!=result.getCode()){
            log.error(result.getMsg());
            return result;
        }
        UserDTO user = result.getData();
        String token = JWTUtils.createJwt(user.getId() + "");
        data.put("token",token);
        return new Response<>()
    }

    @PostMapping("/delete")
    public Response<> login(HttpServletRequest request, @Valid @RequestBody LoginEntity loginDto) {

        String ip = IpAddressUtils.getIpAddr(request);
        // 获取用户信息、比对密码
        Result<UserDTO> result = loginFeignApi.login(loginDto,ip);
        if(ResultCode.SUCCESS.getCode()!=result.getCode()){
            log.error(result.getMsg());
            return result;
        }
        UserDTO user = result.getData();
        String token = JWTUtils.createJwt(user.getId() + "");
        data.put("token",token);
        return new Response<>()
    }

}
