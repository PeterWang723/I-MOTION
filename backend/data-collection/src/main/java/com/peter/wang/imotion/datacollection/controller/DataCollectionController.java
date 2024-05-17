package com.peter.wang.imotion.datacollection.controller;

import com.peter.wang.imotion.datacollection.general_entity.Location;
import com.peter.wang.imotion.datacollection.general_entity.Response;
import com.peter.wang.imotion.datacollection.repository.LocationRepository;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "/dc/v1/")
@Slf4j
public class DataCollectionController {
    @Autowired
    LocationRepository locationRepository;

    @PostMapping("/get_loc")
    public Response<String> getLocation(@RequestBody Location location, @RequestHeader("User") Long user){
        locationRepository.save(location);
        return new Response<>("OK");
    }
}
