package com.exam.payment_service.Controller;
import com.exam.payment_service.DTO.PayCurrentFactureRequest;
import com.exam.payment_service.DTO.PayFacturesRequest;
import com.exam.payment_service.Data.Facture;
import com.exam.payment_service.Service.FactureService;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/factures")
@RequiredArgsConstructor
public class FactureController {

    private final FactureService factureService;

    
    @PostMapping("/pay-current")
    public Facture payCurrent(@RequestBody PayCurrentFactureRequest request) {
        return factureService.payCurrentFacture(request);
    }
    @PostMapping("/pay-specific")
    public List<Facture> paySpecific(@RequestBody PayFacturesRequest request) {
        return factureService.paySpecificFactures(request);
    }
    @GetMapping("/{walletCode}/current")
    public List<Facture> current(
            @PathVariable String walletCode,
            @RequestParam(required = false) String unite
    ) {

        if (unite != null && !unite.isBlank()) {
            return factureService.getCurrentFacturesByUnite(walletCode, unite);
        }

        return factureService.getCurrentFactures(walletCode);
    }
}
