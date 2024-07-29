package com.peter.wang.imotion.gateway.filters;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.auth0.jwt.interfaces.Claim;
import com.peter.wang.imotion.gateway.model.Response;
import com.peter.wang.imotion.gateway.model.ReturnCode;
import com.peter.wang.imotion.gateway.utils.JWTUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.RequestPath;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.net.URI;
import java.util.Map;
import java.util.function.Consumer;

@Slf4j
@Component
public class TokenFilter implements GlobalFilter, Ordered {

    @Autowired
    JWTUtils jwtUtils;

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        URI path = request.getURI();
        String uri = path.getRawPath();
        if (!uri.equals("/userService/auth/login") && !uri.equals("/userService/auth/register")) {
            String token = request.getHeaders().getFirst("Authorization");
            if (token == null || !token.startsWith("Bearer ")) {
                return denyAccess(exchange, ReturnCode.TOKEN_NULL);
            }

            token = token.replace("Bearer ", "");
            Map<String, Claim> claimMap = jwtUtils.parseJwt(token);
            if (claimMap == null || claimMap.containsKey("exception")) {
                log.error("ClaimMap Exception");
                return denyAccess(exchange, ReturnCode.TOKEN_INVALID);
            }

            String userId = claimMap.get("username").asString();
            Consumer<HttpHeaders> headers = httpHeaders -> {
                httpHeaders.add("username", userId);
            };
            request.mutate().headers(headers).build();
        }

        return chain.filter(exchange);
    }

    private Mono<Void> denyAccess(ServerWebExchange exchange, ReturnCode resultCode) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(HttpStatus.FORBIDDEN);
        response.getHeaders().add("Content-Type", "application/json;charset=UTF-8");
        byte[] bytes = JSON.toJSONBytes(
                new Response<String>(resultCode),
                SerializerFeature.WriteMapNullValue
        );
        response.getHeaders().setContentLength(bytes.length);
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        return exchange.getResponse().writeWith(Mono.just(buffer));
    }

    @Override
    public int getOrder() {
        return -1;
    }
}
