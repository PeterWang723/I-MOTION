package com.peter.imotion.dao.general_entity;

import com.peter.imotion.data.Privacy;
import com.peter.imotion.data.Role;
import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Entity
@Data
public class Users implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @OneToMany(mappedBy = "users")
    private List<Log> logs;

    private String username;
    private String password;
    private boolean isExpired;
    private boolean isBlocked;
    private String houseHold;

    @Enumerated(EnumType.STRING)
    private Privacy privacyLevel;

    @Enumerated(EnumType.STRING)
    private Role role;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public boolean isAccountNonExpired() {
        return isExpired;
    }

    @Override
    public boolean isAccountNonLocked() {
        return isBlocked;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
