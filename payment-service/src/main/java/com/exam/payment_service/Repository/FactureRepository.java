package com.exam.payment_service.Repository;

import com.exam.payment_service.Data.Facture;
import org.springframework.data.jpa.repository.JpaRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface FactureRepository extends JpaRepository<Facture, Long> {

    List<Facture> findByWalletCodeAndPaidFalse(String walletCode);
    Optional<Facture> findFirstByWalletCodeAndServiceNameAndAmountAndPaidFalse(
        String walletCode,
        String serviceName,
        BigDecimal amount
);
List<Facture> findByReferenceInAndPaidFalse(List<String> references);
List<Facture> findByWalletCodeAndPaidFalseAndUnite(String walletCode, String unite);
List<Facture> findByWalletCodeAndPaidFalseAndDueDateBetween(
        String walletCode,
        LocalDate debut,
        LocalDate fin
);
}