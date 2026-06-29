package com.exam.badwallet_api.DTO;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;

public record DepositRequest(
        @NotNull @Positive BigDecimal amount,
        @NotBlank String paymentMethod
) {
}