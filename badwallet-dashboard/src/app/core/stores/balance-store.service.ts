import { Injectable, signal } from '@angular/core';
import { WalletApiService } from '../services/wallet-api.service';

@Injectable({
  providedIn: 'root'
})
export class BalanceStoreService {
  readonly balance = signal<number | null>(null);
  readonly phoneNumber = signal<string | null>(null);
  readonly currency = signal<string>('XOF');

  constructor(private walletApiService: WalletApiService) {}

  refresh(phone: string): void {
    this.walletApiService.getBalance(phone).subscribe({
      next: response => {
        this.phoneNumber.set(response.phoneNumber);
        this.balance.set(response.balance);
        this.currency.set(response.currency);
      }
    });
  }

  clear(): void {
    this.balance.set(null);
    this.phoneNumber.set(null);
    this.currency.set('XOF');
  }
}