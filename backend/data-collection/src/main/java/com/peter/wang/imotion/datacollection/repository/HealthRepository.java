package com.peter.wang.imotion.datacollection.repository;

import com.peter.wang.imotion.datacollection.general_entity.Health;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

public interface HealthRepository extends JpaRepository<Health,Long> {
}
