package com.exam.badwallet_api.Service;

import com.exam.badwallet_api.DTO.CreateWalletRequest;
import com.exam.badwallet_api.DTO.WalletBalanceResponse;
import com.exam.badwallet_api.DTO.WalletResponse;
import com.exam.badwallet_api.Data.Wallet;
import org.springframework.data.domain.Page;

public interface WalletService {

    void seedWallets(int numWallets, int eventsPerWallet);
     Wallet createWallet(CreateWalletRequest request);
     Page<WalletResponse> getAllWallets(int page, int size);
     WalletResponse getWalletByPhoneNumber(String phoneNumber);
     WalletBalanceResponse getWalletBalance(String phoneNumber);
}