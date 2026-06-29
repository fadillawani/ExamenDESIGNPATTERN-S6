package com.exam.badwallet_api.Service;

import com.exam.badwallet_api.DTO.CreateWalletRequest;
import com.exam.badwallet_api.Data.Wallet;

public interface WalletService {

    void seedWallets(int numWallets, int eventsPerWallet);
     Wallet createWallet(CreateWalletRequest request);
}