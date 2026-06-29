package com.exam.badwallet_api.Repository;


import com.exam.badwallet_api.Data.Wallet;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WalletRepository extends JpaRepository<Wallet, Long> {

    boolean existsByPhoneNumber(String phoneNumber);

    boolean existsByCode(String code);
}