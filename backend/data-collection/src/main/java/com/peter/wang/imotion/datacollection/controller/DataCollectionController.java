package com.peter.wang.imotion.datacollection.controller;

import com.peter.wang.imotion.datacollection.general_entity.*;
import com.peter.wang.imotion.datacollection.repository.*;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
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
        locations.forEach(location -> location.setUid(u_id));
        locationRepository.saveAll(locations);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_acc")
    public Response<String> saveAcc(@RequestHeader("username") String username, @Valid @RequestBody List<Acceleratometer> acceleratometers){
        Long u_id = Long.parseLong(username);
        acceleratometers.forEach(acc -> acc.setUid(u_id));
        acceleratometerRepository.saveAll(acceleratometers);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_data")
    public Response<String> saveData(@RequestHeader("username") String username, @Valid @RequestBody List<DataUsage> dataUsages){
        Long u_id = Long.parseLong(username);
        dataUsages.forEach(dataUsage -> dataUsage.setUid(u_id));
        dataUsageRepository.saveAll(dataUsages);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_energy")
    public Response<String> saveEnergy(@RequestHeader("username") String username, @Valid @RequestBody List<CarEnergyUsage> carEnergyUsages){
        Long u_id = Long.parseLong(username);
        carEnergyUsages.forEach(carEnergy -> carEnergy.setUid(u_id));
        carEnergyRepository.saveAll(carEnergyUsages);
        return new Response<>(ReturnCode.SUCCESS);
    }

    @PostMapping("/save_health")
    public Response<String> saveHealth(@RequestHeader("username") String username, @Valid @RequestBody List<Health> healths){
        Long u_id = Long.parseLong(username);
        healths.forEach(health -> health.setUid(u_id));
        healthRepository.saveAll(healths);
        return new Response<>(ReturnCode.SUCCESS);
    }
}
