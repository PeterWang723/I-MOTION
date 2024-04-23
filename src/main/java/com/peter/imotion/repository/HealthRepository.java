package com.peter.imotion.repository;

import com.peter.imotion.dao.raw_data.Health;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HealthRepository extends JpaRepository<Health, Long> {

}
