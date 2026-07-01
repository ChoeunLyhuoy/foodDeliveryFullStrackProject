package com.foodgo.repository;

import com.foodgo.entity.SecUser;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface SecUserRepository extends JpaRepository<SecUser, Long> {
    Optional<SecUser> findByUsername(String username);
    Optional<SecUser> findByEmail(String email);
}
