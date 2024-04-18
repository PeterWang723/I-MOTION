package com.peter.imotion.repository;

import com.peter.imotion.dao.Log;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LogRepository extends JpaRepository<Log, Long> {
}
