package com.peter.imotion.survey.repository;

import com.peter.imotion.survey.model.Survey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SurveyRepository extends JpaRepository<Survey, Long> {
    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN TRUE ELSE FALSE END FROM Survey s WHERE s.u_id = :u_id")
    boolean existsByUID(@Param("u_id") Long u_id);
}
