package com.exam.badwallet_api.Service;


import com.exam.badwallet_api.DTO.CreateWalletRequest;
import com.exam.badwallet_api.DTO.DepositRequest;
import com.exam.badwallet_api.DTO.PayRequest;
import com.exam.badwallet_api.DTO.TransferRequest;
import com.exam.badwallet_api.DTO.WalletBalanceResponse;
import com.exam.badwallet_api.DTO.WalletResponse;
import com.exam.badwallet_api.DTO.WithdrawRequest;
import com.exam.badwallet_api.Data.Wallet;
import com.exam.badwallet_api.Data.WalletTransaction;
import com.exam.badwallet_api.Factory.DepositStrategyFactory;
import com.exam.badwallet_api.Proxy.PaymentServiceProxy;
import com.exam.badwallet_api.Repository.WalletRepository;
import com.exam.badwallet_api.Repository.WalletTransactionRepository;
import com.exam.badwallet_api.Strategy.DepositStrategy;

import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

@Service
@RequiredArgsConstructor
public class WalletServiceImpl implements WalletService {

    private final WalletRepository walletRepository;
    private final WalletTransactionRepository transactionRepository;
    private final DepositStrategyFactory depositStrategyFactory;
    private final PaymentServiceProxy paymentServiceProxy;

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
    @Override
    public Page<WalletResponse> getAllWallets(int page, int size) {

        Pageable pageable = PageRequest.of(page, size);

        return walletRepository.findAll(pageable)
                .map(wallet -> new WalletResponse(
                        wallet.getId(),
                        wallet.getPhoneNumber(),
                        wallet.getEmail(),
                        wallet.getBalance(),
                        wallet.getCode(),
                        wallet.getCurrency()
                ));
    }
    @Override
    public WalletResponse getWalletByPhoneNumber(String phoneNumber) {
        Wallet wallet = walletRepository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new RuntimeException("Portefeuille introuvable"));

        return new WalletResponse(
                wallet.getId(),
                wallet.getPhoneNumber(),
                wallet.getEmail(),
                wallet.getBalance(),
                wallet.getCode(),
                wallet.getCurrency()
        );
    }

    @Override
    public WalletBalanceResponse getWalletBalance(String phoneNumber) {
        Wallet wallet = walletRepository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new RuntimeException("Portefeuille introuvable"));

        return new WalletBalanceResponse(
                wallet.getPhoneNumber(),
                wallet.getBalance(),
                wallet.getCurrency()
        );
    }
    @Override
    public WalletResponse deposit(Long walletId, DepositRequest request) {
        DepositStrategy strategy = depositStrategyFactory.getStrategy(request.paymentMethod());

        strategy.validate(request.amount());

        Wallet wallet = walletRepository.findById(walletId)
                .orElseThrow(() -> new RuntimeException("Portefeuille introuvable"));

        wallet.setBalance(wallet.getBalance().add(request.amount()));

        Wallet savedWallet = walletRepository.save(wallet);

        WalletTransaction transaction = WalletTransaction.builder()
                .wallet(savedWallet)
                .type("DEPOSIT_" + request.paymentMethod())
                .amount(request.amount())
                .fees(BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .build();

        transactionRepository.save(transaction);

        return new WalletResponse(
                savedWallet.getId(),
                savedWallet.getPhoneNumber(),
                savedWallet.getEmail(),
                savedWallet.getBalance(),
                savedWallet.getCode(),
                savedWallet.getCurrency()
        );
    }
    @Override
    public WalletResponse withdraw(WithdrawRequest request) {
        Wallet wallet = walletRepository.findByPhoneNumber(request.phoneNumber())
                .orElseThrow(() -> new RuntimeException("Portefeuille introuvable"));

        BigDecimal amount = request.amount();

        BigDecimal fees = amount.multiply(BigDecimal.valueOf(0.01));

        if (fees.compareTo(BigDecimal.valueOf(5000)) > 0) {
            fees = BigDecimal.valueOf(5000);
        }

        BigDecimal totalToDebit = amount.add(fees);

        if (wallet.getBalance().compareTo(totalToDebit) < 0) {
            throw new RuntimeException("Solde insuffisant");
        }

        wallet.setBalance(wallet.getBalance().subtract(totalToDebit));

        Wallet savedWallet = walletRepository.save(wallet);

        WalletTransaction transaction = WalletTransaction.builder()
                .wallet(savedWallet)
                .type("WITHDRAW")
                .amount(amount)
                .fees(fees)
                .createdAt(LocalDateTime.now())
                .build();

        transactionRepository.save(transaction);

        return new WalletResponse(
                savedWallet.getId(),
                savedWallet.getPhoneNumber(),
                savedWallet.getEmail(),
                savedWallet.getBalance(),
                savedWallet.getCode(),
                savedWallet.getCurrency()
        );
    }
    @Override
    public String transfer(TransferRequest request) {
        if (request.senderPhone().equals(request.receiverPhone())) {
            throw new RuntimeException("Le portefeuille source et destination doivent être différents");
        }

        Wallet sender = walletRepository.findByPhoneNumber(request.senderPhone())
                .orElseThrow(() -> new RuntimeException("Portefeuille émetteur introuvable"));

        Wallet receiver = walletRepository.findByPhoneNumber(request.receiverPhone())
                .orElseThrow(() -> new RuntimeException("Portefeuille récepteur introuvable"));

        if (sender.getBalance().compareTo(request.amount()) < 0) {
            throw new RuntimeException("Solde insuffisant");
        }

        sender.setBalance(sender.getBalance().subtract(request.amount()));
        receiver.setBalance(receiver.getBalance().add(request.amount()));

        walletRepository.save(sender);
        walletRepository.save(receiver);

        WalletTransaction senderTransaction = WalletTransaction.builder()
                .wallet(sender)
                .type("TRANSFER_OUT")
                .amount(request.amount())
                .fees(BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .build();

        WalletTransaction receiverTransaction = WalletTransaction.builder()
                .wallet(receiver)
                .type("TRANSFER_IN")
                .amount(request.amount())
                .fees(BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .build();

        transactionRepository.save(senderTransaction);
        transactionRepository.save(receiverTransaction);

        return "Transfert effectué avec succès";
    }

    @Override
    public String payCurrentFacture(PayRequest request) {
        Wallet wallet = walletRepository.findByPhoneNumber(request.phoneNumber())
                .orElseThrow(() -> new RuntimeException("Portefeuille introuvable"));

        if (wallet.getBalance().compareTo(request.amount()) < 0) {
            throw new RuntimeException("Solde insuffisant");
        }

        Object facturePayee = paymentServiceProxy.payCurrentFacture(
        wallet.getCode(),
        request.serviceName(),
        request.amount()
);

        wallet.setBalance(wallet.getBalance().subtract(request.amount()));
        walletRepository.save(wallet);

        WalletTransaction transaction = WalletTransaction.builder()
                .wallet(wallet)
                .type("PAYMENT_" + request.serviceName())
                .amount(request.amount())
                .fees(BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .build();

        transactionRepository.save(transaction);

        return "Paiement effectué avec succès. Facture payée : " + facturePayee;
    }
}