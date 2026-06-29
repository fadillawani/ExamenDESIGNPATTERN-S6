package com.exam.badwallet_api.DTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

import java.math.BigDecimal;

public record CreateWalletRequest(

        @NotBlank(message = "Le numéro de téléphone est obligatoire")
        String phoneNumber,

        @Email(message = "Email invalide")
        @NotBlank(message = "L'email est obligatoire")
        String email,

        @NotNull
        @PositiveOrZero
        BigDecimal initialBalance,

        @NotBlank
        String code,

        @NotBlank
        String currency

) {
}