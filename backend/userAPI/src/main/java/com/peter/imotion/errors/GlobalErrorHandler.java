package com.peter.imotion.errors;

import jakarta.persistence.PersistenceException;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.TransactionSystemException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import lombok.extern.log4j.Log4j2;

@ControllerAdvice
@Slf4j
public class GlobalErrorHandler {

    // Handle database exceptions
    @ExceptionHandler({PersistenceException.class, DataAccessException.class})
    public ResponseEntity<String> handleDatabaseException(Exception ex) {
        // Log the exception details for debugging purposes
        log.error("Database error occurred: " + ex.getMessage());
        // Return a user-friendly message
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error accessing database.");
    }

    // Handle transaction exceptions
    @ExceptionHandler(TransactionSystemException.class)
    public ResponseEntity<String> handleTransactionException(TransactionSystemException ex) {
        log.error("Transaction error occurred: " + ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error during transaction.");
    }

    // Handle any other exceptions not specifically handled
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGenericException(Exception ex) {
        log.error("An error occurred: " + ex.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred.");
    }
}
