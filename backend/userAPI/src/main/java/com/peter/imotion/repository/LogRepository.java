package com.peter.imotion.repository;

import com.peter.imotion.dao.general_entity.Log;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LogRepository extends JpaRepository<Log, Long> {
}
