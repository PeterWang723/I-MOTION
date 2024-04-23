package com.peter.imotion.repository;

import com.peter.imotion.dao.raw_data.Location;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocationRepository extends JpaRepository<Location, Long> {
}
