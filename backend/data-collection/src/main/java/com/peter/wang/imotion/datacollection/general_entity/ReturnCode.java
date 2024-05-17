package com.peter.wang.imotion.datacollection.general_entity;

import lombok.Getter;

@Getter
public enum ReturnCode {
    SUCCESS(100, "请求成功"),
    USER_NOT_EXIST(101, "活动不存在"),
    INVALID_USER_TOKEN(102, "用户信息无效"),
    LACK_PARAM(105, "缺少参数"),
    AUTH_FALSE(106, "验证码错误"),
    EMPTY_STRING(109, "空字符串"),
    INVALID_TYPE(112, "类型错误"),
    INVALID_ADMIN_INFO(301, "管理员登录信息错误");


    private final Integer code;
    private final String message;

    ReturnCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }

}
