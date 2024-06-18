package com.peter.imotion.repository;

import com.peter.imotion.dao.general_entity.Users;
import com.peter.imotion.data.Privacy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface UsersRepository extends JpaRepository<Users, Long> {
    boolean existsByUsernameAndPassword(String username, String password);

    void deleteByUsername(String username);

    boolean existsByUsername(String username);

    Users findByUsername(String username);

    @Modifying
    @Transactional
    @Query("UPDATE Users u SET u.privacyLevel = :privacy WHERE u.id = :id")
    void setPrivacyById(@Param("id") long id, @Param("privacy") Privacy privacy);
}
