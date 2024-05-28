package com.peter.wang.imotion.auth.utils;

import org.springframework.stereotype.Component;

@Component
public class EmailUtils {
    public boolean verifyUserEmail(String code) {

        if (code == null || code.isEmpty()) {
            return false;
        }
        return true;
    }
}
