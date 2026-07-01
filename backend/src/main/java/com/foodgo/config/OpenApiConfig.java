package com.foodgo.config;

import io.swagger.v3.oas.models.ExternalDocumentation;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI foodgoOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("FoodGo Food Delivery API Platform")
                        .description("Comprehensive full-stack API documentation for FoodGo. Serves endpoints for Customer Mobile App, Rider Delivery App, Restaurant Dashboard, and Call Center Dispatch Queue.")
                        .version("v1.0.0")
                        .contact(new Contact()
                                .name("FoodGo Engineering Team")
                                .email("support@foodgo.com")
                                .url("https://github.com/ChoeunLyhuoy/foodDeliveryFullStrackProject"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0")))
                .servers(List.of(
                        new Server().url("http://localhost:8088").description("Docker Compose External Server"),
                        new Server().url("http://localhost:8080").description("Local Spring Boot Direct Server")
                ))
                .externalDocs(new ExternalDocumentation()
                        .description("FoodGo Full-Stack GitHub Repository")
                        .url("https://github.com/ChoeunLyhuoy/foodDeliveryFullStrackProject"));
    }
}
