package com.foodgo.controller;

import com.foodgo.dto.AuthResponse;
import com.foodgo.dto.LoginRequest;
import com.foodgo.entity.SecUser;
import com.foodgo.entity.User;
import com.foodgo.repository.SecUserRepository;
import com.foodgo.repository.UserRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication & SecUser", description = "Endpoints for role-based login across tb user and secUser")
public class AuthController {

    private final UserRepository userRepository;
    private final SecUserRepository secUserRepository;

    @Operation(summary = "Login or Sign-in user by role checking both tb user and secUser")
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        String identifier = request.getIdentifier() != null ? request.getIdentifier() : "alice@example.com";
        String requestedRole = request.getRole() != null ? request.getRole().toUpperCase() : "CUSTOMER";

        // 1. Check in secUser table first if role matches security admin or sec account
        Optional<SecUser> secOpt = secUserRepository.findByEmail(identifier);
        if (secOpt.isEmpty()) {
            secOpt = secUserRepository.findByUsername(identifier);
        }
        if (secOpt.isPresent()) {
            SecUser su = secOpt.get();
            su.setLastLogin(LocalDateTime.now());
            secUserRepository.save(su);
            return ResponseEntity.ok(new AuthResponse(
                    "jwt-sec-token-" + su.getId(),
                    su.getId(),
                    su.getUsername(),
                    su.getEmail(),
                    su.getRole(),
                    "secUser"
            ));
        }

        // 2. Check in tb user table
        Optional<User> userOpt = userRepository.findByEmail(identifier);
        if (userOpt.isPresent()) {
            User u = userOpt.get();
            return ResponseEntity.ok(new AuthResponse(
                    "jwt-tb-user-token-" + u.getId(),
                    u.getId(),
                    u.getName(),
                    u.getEmail(),
                    u.getRole().name(),
                    "tbUser"
            ));
        }

        // 3. Fallback or auto-provision for test login if user enters custom phone/email
        User autoUser = new User();
        autoUser.setName(identifier.contains("@") ? identifier.substring(0, identifier.indexOf('@')) : identifier);
        autoUser.setEmail(identifier.contains("@") ? identifier : identifier + "@foodgo.com");
        autoUser.setPhone(identifier);
        autoUser.setPasswordHash("$2a$10$auto");
        try {
            autoUser.setRole(User.Role.valueOf(requestedRole));
        } catch (Exception e) {
            autoUser.setRole(User.Role.CUSTOMER);
        }
        autoUser = userRepository.save(autoUser);

        return ResponseEntity.ok(new AuthResponse(
                "jwt-auto-token-" + autoUser.getId(),
                autoUser.getId(),
                autoUser.getName(),
                autoUser.getEmail(),
                autoUser.getRole().name(),
                "tbUser"
        ));
    }

    @Operation(summary = "Get all users and secUsers")
    @GetMapping("/users")
    public ResponseEntity<Map<String, Object>> getAllUsers() {
        Map<String, Object> result = new HashMap<>();
        result.put("tbUsers", userRepository.findAll());
        result.put("secUsers", secUserRepository.findAll());
        return ResponseEntity.ok(result);
    }
}
