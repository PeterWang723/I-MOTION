package com.peter.wang.imotion.datacollection.controller;

import com.peter.wang.imotion.datacollection.general_entity.*;
import com.peter.wang.imotion.datacollection.repository.*;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/dc")
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
    public Response<String> saveLocation(@RequestHeader("username") String username, @Valid @RequestBody List<Location> locations){
        Long u_id = Long.parseLong(username);
        for (Location location : locations) {
            location.setUid(u_id);
        }
        locationRepository.saveAll(locations);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_acc")
    public Response<String> saveAcc(@RequestHeader("username") String username, @Valid @RequestBody List<Acceleratometer> acceleratometers){
        acceleratometerRepository.saveAll(acceleratometers);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_data")
    public Response<String> saveData(@RequestHeader("username") String username, @Valid @RequestBody List<DataUsage> dataUsages){
        dataUsageRepository.saveAll(dataUsages);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_energy")
    public Response<String> saveEnergy(@RequestHeader("username") String username, @Valid @RequestBody List<CarEnergyUsage> carEnergyUsages){
        carEnergyRepository.saveAll(carEnergyUsages);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_health")
    public Response<String> saveHealth(@RequestHeader("username") String username, @Valid @RequestBody List<Health> healths){
        healthRepository.saveAll(healths);
        return new Response<>(ReturnCode.SUCCESS);
    }
}
