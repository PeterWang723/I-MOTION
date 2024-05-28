package com.peter.wang.imotion.auth.feign;

import com.peter.wang.imotion.auth.model.Response;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(name = "user-api", url="http://localhost:8080")
public interface UserClient {
    @GetMapping("/login")
    Response<String> getUser(@RequestParam("email") String email, @RequestParam("password") String password);
}
