package com.peter.imotion.survey.controller;

import com.peter.imotion.survey.model.Response;
import com.peter.imotion.survey.model.ReturnCode;
import com.peter.imotion.survey.model.Survey;
import com.peter.imotion.survey.repository.SurveyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/survey")
public class SurveyController {
    @Autowired
    SurveyRepository surveyRepository;

    @PostMapping("/save_survey")
    public Response<String> saveLocation(@RequestHeader("username") String username, @RequestBody Survey survey){
        Long u_id = Long.parseLong(username);
        survey.setU_id(u_id);
        surveyRepository.save(survey);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @GetMapping("/get_survey")
    public Response<String> getSurvey(@RequestHeader("username") String username){
        Long u_id = Long.parseLong(username);
        if (surveyRepository.existsById(u_id)){
            return new Response<>(ReturnCode.SUCCESS);
        } else {
            return new Response<>(ReturnCode.USER_NOT_EXIST);
        }
    }
}
