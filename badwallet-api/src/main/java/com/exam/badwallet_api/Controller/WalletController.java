package com.exam.badwallet_api.Controller;


import com.exam.badwallet_api.DTO.CreateWalletRequest;
import com.exam.badwallet_api.Data.Wallet;
import com.exam.badwallet_api.Service.WalletService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/wallets")
@RequiredArgsConstructor
public class WalletController {

    private final WalletService walletService;

    @PostMapping("/seed")
    public String seed(
            @RequestParam int numWallets,
            @RequestParam int eventsPerWallet
    ) {
        walletService.seedWallets(numWallets, eventsPerWallet);
        return "Seed lancé en arrière-plan";
    }

    @PostMapping
    public Wallet createWallet(@Valid @RequestBody CreateWalletRequest request) {
        return walletService.createWallet(request);
    }
}