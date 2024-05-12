package com.peter.wang.imotion.gateway.filters;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.auth0.jwt.interfaces.Claim;
import com.peter.wang.imotion.gateway.model.Response;
import com.peter.wang.imotion.gateway.model.ReturnCode;
import com.peter.wang.imotion.gateway.utils.JWTUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import java.util.Map;
import java.util.function.Consumer;

@Slf4j
@Component
public class TokenFilter implements GlobalFilter, Ordered {

    JWTUtils jwtUtils;

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String token = request.getHeaders().getFirst("Authorization");

        if (token == null || !token.startsWith("Bearer ")) {
            return denyAccess(exchange, ReturnCode.TOKEN_NULL);
        }

        Map<String, Claim> claimMap = jwtUtils.parseJwt(token);
        //token有误
        if (claimMap.containsKey("exception")) {
            log.error(claimMap.get("exception").toString());
            return denyAccess(exchange, ReturnCode.TOKEN_INVALID);
        }

        //token无误，将用户信息设置进header中,传递到下游服务
        String userId = claimMap.get("username").asString();
        Consumer<HttpHeaders> headers = httpHeaders -> {
            httpHeaders.add("username", userId);
        };
        request.mutate().headers(headers).build();

        return chain.filter(exchange);
    }

    private Mono<Void> denyAccess(ServerWebExchange exchange, ReturnCode resultCode) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(HttpStatus.OK);
        response.getHeaders().add("Content-Type", "application/json;charset=UTF-8");
        byte[] bytes = JSON.toJSONBytes(
                Response.builder().status(resultCode.getCode()).message(resultCode.getMessage()),
                SerializerFeature.WriteMapNullValue
        );
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        return response.writeWith(Mono.just(buffer));

    }

    @Override
    public int getOrder() {
        return -1;
    }
}
