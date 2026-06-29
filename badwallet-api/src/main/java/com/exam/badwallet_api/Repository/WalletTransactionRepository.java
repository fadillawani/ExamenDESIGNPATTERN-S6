package com.exam.badwallet_api.Repository;


import com.exam.badwallet_api.Data.WalletTransaction;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WalletTransactionRepository extends JpaRepository<WalletTransaction, Long> {
}