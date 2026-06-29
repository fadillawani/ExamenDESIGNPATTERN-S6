package com.exam.badwallet_api.Service;


import com.exam.badwallet_api.DTO.CreateWalletRequest;
import com.exam.badwallet_api.Data.Wallet;
import com.exam.badwallet_api.Data.WalletTransaction;
import com.exam.badwallet_api.Repository.WalletRepository;
import com.exam.badwallet_api.Repository.WalletTransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class WalletServiceImpl implements WalletService {

    private final WalletRepository walletRepository;
    private final WalletTransactionRepository transactionRepository;

    @Async
@Override
public void seedWallets(int numWallets, int eventsPerWallet) {
    for (int i = 1; i <= numWallets; i++) {
        String phoneNumber = String.format("+221770000%03d", i);
        String code = String.format("WLT-%07d", i);

        if (!walletRepository.existsByPhoneNumber(phoneNumber)
                && !walletRepository.existsByCode(code)) {

            Wallet wallet = Wallet.builder()
                    .phoneNumber(phoneNumber)
                    .code(code)
                    .email("client" + i + "@gmail.com")
                    .balance(BigDecimal.valueOf(100000))
                    .currency("XOF")
                    .build();

            walletRepository.save(wallet);

            for (int j = 1; j <= eventsPerWallet; j++) {
                WalletTransaction transaction = WalletTransaction.builder()
                        .wallet(wallet)
                        .type("SEED_EVENT")
                        .amount(BigDecimal.valueOf(1000))
                        .fees(BigDecimal.ZERO)
                        .createdAt(LocalDateTime.now())
                        .build();

                transactionRepository.save(transaction);
            }
        }
    }
}


@Override
public Wallet createWallet(CreateWalletRequest request) {
    if (walletRepository.existsByPhoneNumber(request.phoneNumber())) {
        throw new RuntimeException("Ce numéro possède déjà un portefeuille");
    }

    if (walletRepository.existsByCode(request.code())) {
        throw new RuntimeException("Ce code wallet existe déjà");
    }

    Wallet wallet = Wallet.builder()
            .phoneNumber(request.phoneNumber())
            .email(request.email())
            .balance(request.initialBalance())
            .code(request.code())
            .currency(request.currency())
            .build();

    return walletRepository.save(wallet);
}
}