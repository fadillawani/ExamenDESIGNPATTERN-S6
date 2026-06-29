package com.exam.badwallet_api.Factory;

import com.exam.badwallet_api.Strategy.DepositStrategy;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DepositStrategyFactory {

    private final List<DepositStrategy> strategies;

    public DepositStrategyFactory(List<DepositStrategy> strategies) {
        this.strategies = strategies;
    }

    public DepositStrategy getStrategy(String paymentMethod) {
        return strategies.stream()
                .filter(strategy -> strategy.getPaymentMethod().equalsIgnoreCase(paymentMethod))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Méthode de paiement non supportée : " + paymentMethod));
    }
}