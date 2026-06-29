package com.exam.badwallet_api.DTO;

import java.math.BigDecimal;

public record WalletResponse(
        Long id,
        String phoneNumber,
        String email,
        BigDecimal balance,
        String code,
        String currency
) {
}