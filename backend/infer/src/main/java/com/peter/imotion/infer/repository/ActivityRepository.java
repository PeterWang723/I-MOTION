package com.peter.imotion.infer.repository;

import com.peter.imotion.infer.general_entity.Activity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

public interface ActivityRepository extends JpaRepository<Activity, Long> {
    @Query("SELECT a FROM Activity a WHERE a.u_id = :userId AND a.day = :startDate")
    List<Activity> findByUserIdAndDate(@Param("userId") Long userId, @Param("startDate") Date startDate);

    @Query("UPDATE Activity a SET a.mode = :mode, a.day = :day, a.start_time = :start_time, a.end_time = :end_time, " +
            "a.origin = :origin, a.destination = :destination, a.activities = :activities, a.cost = :cost, " +
            "a.luggage_num = :luggage_num, a.luggage_type = :luggage_type, a.luggage_weight = :luggage_weight, " +
            "a.travel_car_cost = :travel_car_cost " +
            "WHERE a.id = :id AND a.u_id = :u_id")
    int updateActivityByIdAndUId(long id, long u_id, String mode, Date day, Date start_time, Date end_time,
                                 String origin, String destination, String activities, Integer cost,
                                 Integer luggage_num, Integer luggage_type, Integer luggage_weight,
                                 Integer travel_car_cost);
}
