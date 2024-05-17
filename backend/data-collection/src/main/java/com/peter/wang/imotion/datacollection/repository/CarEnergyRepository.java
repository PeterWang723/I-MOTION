package com.peter.wang.imotion.datacollection.repository;

import com.peter.wang.imotion.datacollection.general_entity.CarEnergyUsage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CarEnergyRepository extends JpaRepository<CarEnergyUsage, Long> {
}
