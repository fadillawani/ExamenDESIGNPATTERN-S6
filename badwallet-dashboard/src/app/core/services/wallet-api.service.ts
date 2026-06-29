import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { BalanceResponse } from '../models/balance.model';

import { PageResponse, Wallet } from '../models/wallet.model';

export interface CreateWalletRequest {
  phoneNumber: string;
  email: string;
  initialBalance: number;
  code: string;
  currency: string;
}

export interface DepositRequest {
  amount: number;
  paymentMethod: string;
}

export interface WithdrawRequest {
  phoneNumber: string;
  amount: number;
}

export interface TransferRequest {
  senderPhone: string;
  receiverPhone: string;
  amount: number;
}

@Injectable({
  providedIn: 'root'
})
export class WalletApiService {
  private readonly BASE_URL = 'http://localhost:8080/api/wallets';

  constructor(private http: HttpClient) {}

  getWallets(page: number, size: number): Observable<PageResponse<Wallet>> {
    const params = new HttpParams()
      .set('page', page)
      .set('size', size);

    return this.http.get<PageResponse<Wallet>>(this.BASE_URL, { params });
  }

  createWallet(payload: CreateWalletRequest): Observable<Wallet> {
    return this.http.post<Wallet>(this.BASE_URL, payload);
  }

  getWalletByPhone(phone: string): Observable<Wallet> {
    const encodedPhone = encodeURIComponent(phone);
    return this.http.get<Wallet>(`${this.BASE_URL}/${encodedPhone}`);
  }

  deposit(walletId: number, payload: DepositRequest): Observable<Wallet> {
    return this.http.post<Wallet>(
      `${this.BASE_URL}/${walletId}/deposit`,
      payload
    );
  }

  withdraw(payload: WithdrawRequest): Observable<Wallet> {
    return this.http.post<Wallet>(
      `${this.BASE_URL}/withdraw`,
      payload
    );
  }
  getBalance(phone: string): Observable<BalanceResponse> {
  const encodedPhone = encodeURIComponent(phone);
  return this.http.get<BalanceResponse>(`${this.BASE_URL}/${encodedPhone}/balance`);
  
}
transfer(payload: TransferRequest): Observable<string> {
  return this.http.post(
    `${this.BASE_URL}/transfer`,
    payload,
    { responseType: 'text' }
  );
}


}