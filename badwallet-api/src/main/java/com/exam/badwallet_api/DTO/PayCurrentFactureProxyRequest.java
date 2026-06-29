package com.exam.badwallet_api.DTO;

import java.math.BigDecimal;

public record PayCurrentFactureProxyRequest(
        String walletCode,
        String serviceName,
        BigDecimal amount
) {
}