package com.exam.badwallet_api.DTO;

import java.math.BigDecimal;

public record WalletBalanceResponse(
        String phoneNumber,
        BigDecimal balance,
        String currency
) {
}