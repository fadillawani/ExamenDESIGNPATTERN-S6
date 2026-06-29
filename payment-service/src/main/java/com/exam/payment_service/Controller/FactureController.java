package com.exam.payment_service.Controller;
import com.exam.payment_service.DTO.PayCurrentFactureRequest;
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

    @GetMapping("/{walletCode}/current")
    public List<Facture> current(@PathVariable String walletCode) {
        return factureService.getCurrentFactures(walletCode);
    }
    @PostMapping("/pay-current")
    public Facture payCurrent(@RequestBody PayCurrentFactureRequest request) {
        return factureService.payCurrentFacture(request);
    }
}
