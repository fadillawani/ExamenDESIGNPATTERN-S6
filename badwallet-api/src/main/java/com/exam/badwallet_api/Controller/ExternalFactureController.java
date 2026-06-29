package com.exam.badwallet_api.Controller;

import com.exam.badwallet_api.Proxy.PaymentServiceProxy;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/external/factures")
@RequiredArgsConstructor
public class ExternalFactureController {

    private final PaymentServiceProxy paymentServiceProxy;

    
    @GetMapping("/{walletCode}/current")
    public ResponseEntity<Object> getCurrentFactures(
            @PathVariable String walletCode,
            @RequestParam(required = false) String unite
    ) {
        return ResponseEntity.ok(paymentServiceProxy.getCurrentFactures(walletCode, unite));
    }
    @GetMapping("/{walletCode}/periode")
    public ResponseEntity<Object> getFacturesByPeriode(
            @PathVariable String walletCode,
            @RequestParam String debut,
            @RequestParam String fin
    ) {

        return ResponseEntity.ok(
                paymentServiceProxy.getFacturesByPeriode(
                        walletCode,
                        debut,
                        fin
                )
        );
    }
}