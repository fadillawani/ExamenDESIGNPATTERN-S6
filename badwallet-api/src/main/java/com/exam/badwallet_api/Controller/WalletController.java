package com.exam.badwallet_api.Controller;


import com.exam.badwallet_api.DTO.CreateWalletRequest;
import com.exam.badwallet_api.DTO.DepositRequest;
import com.exam.badwallet_api.DTO.PayFacturesRequest;
import com.exam.badwallet_api.DTO.PayRequest;
import com.exam.badwallet_api.DTO.TransactionResponse;
import com.exam.badwallet_api.DTO.TransferRequest;
import com.exam.badwallet_api.DTO.WalletBalanceResponse;
import com.exam.badwallet_api.DTO.WalletResponse;
import com.exam.badwallet_api.DTO.WithdrawRequest;
import com.exam.badwallet_api.Data.Wallet;
import com.exam.badwallet_api.Service.WalletService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;
import java.util.List;
@CrossOrigin(origins = "http://localhost:4200")
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

    @GetMapping
    public ResponseEntity<Page<WalletResponse>> getAllWallets(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        return ResponseEntity.ok(walletService.getAllWallets(page, size));
    }
    @GetMapping("/{phoneNumber}")
    public ResponseEntity<WalletResponse> getWalletByPhoneNumber(
            @PathVariable String phoneNumber
    ) {
        return ResponseEntity.ok(walletService.getWalletByPhoneNumber(phoneNumber));
    }
    @GetMapping("/{phoneNumber}/balance")
    public ResponseEntity<WalletBalanceResponse> getWalletBalance(
            @PathVariable String phoneNumber
    ) {
        return ResponseEntity.ok(walletService.getWalletBalance(phoneNumber));
    }
    @PostMapping("/{id}/deposit")
    public ResponseEntity<WalletResponse> deposit(
            @PathVariable Long id,
            @Valid @RequestBody DepositRequest request
    ) {
        return ResponseEntity.ok(walletService.deposit(id, request));
    }
    @PostMapping("/withdraw")
    public ResponseEntity<WalletResponse> withdraw(
            @Valid @RequestBody WithdrawRequest request
    ) {
        return ResponseEntity.ok(walletService.withdraw(request));
    }
    @PostMapping("/transfer")
    public ResponseEntity<String> transfer(
            @Valid @RequestBody TransferRequest request
    ) {
        return ResponseEntity.ok(walletService.transfer(request));
    }
    @PostMapping("/pay")
    public ResponseEntity<String> payCurrentFacture(
            @Valid @RequestBody PayRequest request
    ) {
        return ResponseEntity.ok(walletService.payCurrentFacture(request));
    }
    @PostMapping("/pay-factures")
    public ResponseEntity<Object> paySpecificFactures(
            @Valid @RequestBody PayFacturesRequest request
    ) {
        return ResponseEntity.ok(walletService.paySpecificFactures(request));
    }
    @GetMapping("/{phoneNumber}/transactions")
    public ResponseEntity<List<TransactionResponse>> getTransactionsByPhoneNumber(
            @PathVariable String phoneNumber
    ) {
        return ResponseEntity.ok(walletService.getTransactionsByPhoneNumber(phoneNumber));
    }
}