package com.foodgo.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
public class CreateOrderRequest {
    @NotNull
    private Long customerId;
    @NotNull
    private Long restaurantId;
    @NotNull
    private String deliveryAddress;
    @NotEmpty
    private List<Item> items;

    @Getter
    @Setter
    public static class Item {
        private Long menuItemId;
        private Integer quantity;
        private String notes;
    }
}
