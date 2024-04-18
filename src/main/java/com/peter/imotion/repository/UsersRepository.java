package com.peter.imotion.repository;

import com.peter.imotion.dao.Users;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UsersRepository extends JpaRepository<Users, Long> {
}
