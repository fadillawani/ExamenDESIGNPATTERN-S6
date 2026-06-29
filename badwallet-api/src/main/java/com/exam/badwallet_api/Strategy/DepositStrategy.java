package com.exam.badwallet_api.Strategy;

import java.math.BigDecimal;

public interface DepositStrategy {

    String getPaymentMethod();

    void validate(BigDecimal amount);
}