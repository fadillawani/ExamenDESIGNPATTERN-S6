package com.exam.payment_service.DTO;

import java.math.BigDecimal;

public record PayCurrentFactureRequest(
        String walletCode,
        String serviceName,
        BigDecimal amount
) {
}