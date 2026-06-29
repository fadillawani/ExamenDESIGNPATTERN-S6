package com.exam.badwallet_api.DTO;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TransactionResponse(
        Long id,
        String type,
        BigDecimal amount,
        BigDecimal fees,
        LocalDateTime createdAt
) {
}