package com.peter.wang.imotion.datacollection.repository;

import com.peter.wang.imotion.datacollection.general_entity.DataUsage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DataUsageRepository extends JpaRepository<DataUsage, Long> {
}
