package com.peter.wang.imotion.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    
    public void sendEmail(){
        int a = 1;
    }
}
//@Autowired
//private JavaMailSender mailSender;

//@Value("$(spring.mail.username)")
//private String fromEmail;

//public void sendEmail(String to, String subject, String content) {
//    SimpleMailMessage message = new SimpleMailMessage();
//    message.setTo(to);
//    message.setSubject(subject);
//    message.setText(content);
//    message.setFrom(fromEmail);

//    mailSender.send(message);
//}
