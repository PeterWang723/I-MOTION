package com.peter.imotion.infer.general_entity;


import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Response<T> {
    public int status;

    public String message;
    public T data;

    public Response() {
        this.message = ReturnCode.SUCCESS.getMessage();
        this.status = ReturnCode.SUCCESS.getCode();
    }

    public Response(int status, String message, T data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }

    public Response(T data) {
        this.data = data;
        this.message = ReturnCode.SUCCESS.getMessage();
        this.status = ReturnCode.SUCCESS.getCode();
    }

    public Response(ReturnCode rc) {
        this.message = rc.getMessage();
        this.status = rc.getCode();
    }

    public Response(ReturnCode rc, T data) {
        this.message = rc.getMessage();
        this.status = rc.getCode();
        this.data = data;
    }
}
