package com.peter.wang.imotion.auth.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JWTUtils {

    private static final String SECRET_KEY = "secretKey:123456";

    public static final long TOKEN_EXPIRE_TIME = 7200 * 1000;

    public String createJwt(String userId){
        Algorithm algorithm = Algorithm.HMAC256(SECRET_KEY);
        //设置头信息
        HashMap<String, Object> header = new HashMap<String, Object>(2);
        header.put("typ", "JWT");
        header.put("alg", "HS256");
        // 生成 token：头部+载荷+签名
        return JWT.create().withHeader(header)
                .withClaim("username",userId)
                .withExpiresAt(new Date(System.currentTimeMillis()+TOKEN_EXPIRE_TIME)).sign(algorithm);
    }

    public Map<String, Claim> parseJwt(String token) {
        Map<String, Claim> claims = null;
        try {
            Algorithm algorithm = Algorithm.HMAC256(SECRET_KEY);
            JWTVerifier verifier = JWT.require(algorithm).build();
            DecodedJWT jwt = verifier.verify(token);
            claims = jwt.getClaims();
            return claims;
        } catch (Exception e) {
            return null;
        }
    }
}

