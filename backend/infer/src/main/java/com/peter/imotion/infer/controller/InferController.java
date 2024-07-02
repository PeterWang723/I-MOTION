package com.peter.imotion.infer.controller;

import com.peter.imotion.infer.general_entity.Activity;
import com.peter.imotion.infer.general_entity.Purpose;
import com.peter.imotion.infer.general_entity.Response;
import com.peter.imotion.infer.general_entity.ReturnCode;
import com.peter.imotion.infer.repository.ActivityRepository;
import com.peter.imotion.infer.repository.PurposeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping(path = "/infer")
public class InferController {
    @Autowired
    private ActivityRepository activityRepository;


    @GetMapping("/get_infer/{date}")
    public Response<List<Activity>> get_infer(@RequestHeader Long username, @PathVariable @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) {
        List<Activity> activities = activityRepository.findByUserIdAndDate(username, date);
        return new Response<>(ReturnCode.SUCCESS, activities);
    }


    @PostMapping("/update_infer")
    public Response<String> update_infer(@RequestHeader Long username, @RequestBody Activity activity) {
        activity.setU_id(username);
        if (activity.getPurposes() != null) {
            for (Purpose purpose : activity.getPurposes()) {
                purpose.setActivity(activity);
            }
        }
        activityRepository.save(activity);

        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/post_infer")
    public Response<String> post_infer(@RequestHeader Long username, @RequestBody List<Activity> activities) {
        for (Activity activity : activities) {
            activity.setU_id(username);
            if (activity.getPurposes() != null) {
                for (Purpose purpose : activity.getPurposes()) {
                    purpose.setActivity(activity);
                }
            }
            activityRepository.save(activity);
        }
        return new Response<>(ReturnCode.SUCCESS);
    }
}
