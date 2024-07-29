package com.peter.imotion.survey.repository;

import com.peter.imotion.survey.model.Survey;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SurveyRepository extends JpaRepository<Survey, Long> {
}
