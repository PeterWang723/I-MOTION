package com.peter.imotion.infer.controller;

import com.peter.imotion.infer.general_entity.Activity;
import com.peter.imotion.infer.general_entity.Response;
import com.peter.imotion.infer.general_entity.ReturnCode;
import com.peter.imotion.infer.repository.ActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping(path = "/infer/v1/")
public class InferController {
    @Autowired
    private ActivityRepository activityRepository;

    @GetMapping("/get_infer/{user_id}/{date}")
    public Response<List<Activity>> get_infer(@PathVariable Long user_id, @PathVariable @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) {
        List<Activity> activities = activityRepository.findByUserIdAndDate(user_id, date);
        return new Response<>(ReturnCode.SUCCESS, activities);
    }

    @PostMapping("/update_infer")
    public Response<String> update_infer(@RequestBody List<Activity> activities) {
        for (Activity activity : activities) {
            activityRepository.updateActivityByIdAndUId(activity.getId(), activity.getU_id(), activity.getMode(), activity.getDay(),
                    activity.getStart_time(), activity.getEnd_time(), activity.getOrigin(),
                    activity.getDestination(), activity.getActivities(), activity.getCost(),
                    activity.getLuggage_num(), activity.getLuggage_type(), activity.getLuggage_weight(),
                    activity.getTravel_car_cost());
        }
        return new Response<>(ReturnCode.SUCCESS);
    }
}
