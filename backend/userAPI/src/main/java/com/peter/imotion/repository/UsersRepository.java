package com.peter.imotion.repository;

import com.peter.imotion.dao.general_entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsersRepository extends JpaRepository<Users, Long> {
    boolean existsByUsernameAndPassword(String username, String password);

    void deleteByUsername(String username);

    boolean existsByUsername(String username);

    Users findByUsername(String username);
}
