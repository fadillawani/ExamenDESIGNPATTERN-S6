package com.exam.payment_service.Service;
import com.exam.payment_service.DTO.PayCurrentFactureRequest;
import com.exam.payment_service.Data.Facture;
import com.exam.payment_service.Repository.FactureRepository;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FactureService {

    private final FactureRepository factureRepository;

    public List<Facture> getCurrentFactures(String walletCode) {
        return factureRepository.findByWalletCodeAndPaidFalse(walletCode);
    }
    public Facture payCurrentFacture(PayCurrentFactureRequest request) {
    Facture facture = factureRepository
            .findFirstByWalletCodeAndServiceNameAndAmountAndPaidFalse(
                    request.walletCode(),
                    request.serviceName(),
                    request.amount()
            )
            .orElseThrow(() -> new RuntimeException("Facture impayée introuvable"));

    facture.setPaid(true);

    return factureRepository.save(facture);
}
}