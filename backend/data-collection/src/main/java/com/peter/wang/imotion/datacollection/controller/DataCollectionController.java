package com.peter.wang.imotion.datacollection.controller;

import com.peter.wang.imotion.datacollection.general_entity.*;
import com.peter.wang.imotion.datacollection.repository.*;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "/dc/v1/")
@Slf4j
public class DataCollectionController {
    @Autowired
    LocationRepository locationRepository;

    @Autowired
    AcceleratometerRepository acceleratometerRepository;

    @Autowired
    DataUsageRepository dataUsageRepository;

    @Autowired
    CarEnergyRepository carEnergyRepository;

    @Autowired
    HealthRepository healthRepository;

    @PostMapping("/save_loc")
    public Response<String> saveLocation(@Valid @RequestBody Location location){
        locationRepository.save(location);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_acc")
    public Response<String> saveAcc(@Valid @RequestBody Acceleratometer acceleratometer){
        acceleratometerRepository.save(acceleratometer);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_data")
    public Response<String> saveData(@Valid @RequestBody DataUsage dataUsage){
        dataUsageRepository.save(dataUsage);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_energy")
    public Response<String> saveEnergy(@Valid @RequestBody CarEnergyUsage carEnergyUsage){
        carEnergyRepository.save(carEnergyUsage);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_health")
    public Response<String> saveHealth(@Valid @RequestBody Health health){
        healthRepository.save(health);
        return new Response<>(ReturnCode.SUCCESS);
    }
}
