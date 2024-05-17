package com.peter.wang.imotion.datacollection.repository;

import com.peter.wang.imotion.datacollection.general_entity.Acceleratometer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AcceleratometerRepository extends JpaRepository<Acceleratometer, Long> {
}
