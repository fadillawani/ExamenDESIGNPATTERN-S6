package com.exam.payment_service.Repository;

import com.exam.payment_service.Data.Facture;
import org.springframework.data.jpa.repository.JpaRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface FactureRepository extends JpaRepository<Facture, Long> {

    List<Facture> findByWalletCodeAndPaidFalse(String walletCode);
    Optional<Facture> findFirstByWalletCodeAndServiceNameAndAmountAndPaidFalse(
        String walletCode,
        String serviceName,
        BigDecimal amount
);
}