package com.peter.wang.imotion.datacollection.repository;

import com.peter.wang.imotion.datacollection.general_entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocationRepository extends JpaRepository<Location, Long> {
}
