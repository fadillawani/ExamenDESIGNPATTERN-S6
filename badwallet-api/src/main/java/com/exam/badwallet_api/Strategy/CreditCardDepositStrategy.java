package com.exam.badwallet_api.Strategy;

import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class CreditCardDepositStrategy implements DepositStrategy {

    @Override
    public String getPaymentMethod() {
        return "CREDIT_CARD";
    }

    @Override
    public void validate(BigDecimal amount) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Le montant du dépôt doit être positif");
        }
    }
}