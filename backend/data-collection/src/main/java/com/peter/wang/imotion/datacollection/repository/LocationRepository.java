package com.peter.wang.imotion.datacollection.repository;

import com.peter.wang.imotion.datacollection.general_entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;

public interface LocationRepository extends JpaRepository<Location, Long> {
    List<Location> findByUidAndCreatedTimeBetween(Long uid, Date startDate, Date endDate);

    boolean existsByUid(Long uid);
}

