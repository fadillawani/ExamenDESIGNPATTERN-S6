package com.exam.badwallet_api.DTO;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public record PayFacturesRequest(
        @NotBlank String phoneNumber,
        @NotBlank String serviceName,
        @NotEmpty List<String> factureReferences
) {
}