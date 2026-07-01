package com.foodgo.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String identifier; // email, phone, or username
    private String password;
    private String role;
}
