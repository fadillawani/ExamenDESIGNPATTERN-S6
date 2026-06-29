package com.exam.badwallet_api.Repository;


import com.exam.badwallet_api.Data.WalletTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WalletTransactionRepository extends JpaRepository<WalletTransaction, Long> {
    List<WalletTransaction> findByWalletPhoneNumberOrderByCreatedAtDesc(String phoneNumber);
}