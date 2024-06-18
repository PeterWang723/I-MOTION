package com.peter.wang.imotion.auth.feign;

import com.peter.wang.imotion.auth.model.LoginEntity;
import com.peter.wang.imotion.auth.model.Response;
import com.peter.wang.imotion.auth.model.Users;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "user-api", url="http://userapi-service:8081/user")
public interface UserClient {
    @PostMapping("/login")
    Response<String> getUser(@RequestBody LoginEntity user);

    @PostMapping("/register")
    Response<String> registerUser(@RequestBody Users user);

    @PostMapping("/delete")
    Response<String> deleteUser(@RequestBody Users user);
}
