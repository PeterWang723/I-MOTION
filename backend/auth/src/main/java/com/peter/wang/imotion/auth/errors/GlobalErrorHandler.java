package com.peter.wang.imotion.auth.errors;

import feign.FeignException;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.validation.FieldError;

import java.util.Map;
import java.util.stream.Collectors;

@ControllerAdvice
public class GlobalErrorHandler {

    // Handle any other exceptions not specifically handled
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGenericException(Exception ex) {
        System.out.println("An error occurred: " + ex.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred.");
    }

    @ExceptionHandler(FeignException.class)
    public ResponseEntity<String> handleFeignStatusException(FeignException e, HttpServletResponse response) {
        return new ResponseEntity<>(e.contentUTF8(), HttpStatus.valueOf(e.status()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .collect(Collectors.toMap(FieldError::getField, FieldError::getDefaultMessage));
        return ResponseEntity.badRequest().body(errors);
    }
}
