import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { WalletApiService } from '../../../core/services/wallet-api.service';
import { Wallet } from '../../../core/models/wallet.model';
import { XofPipe } from '../../../shared/pipes/xof.pipe';
import { PhoneFormatPipe } from '../../../shared/pipes/phone-format.pipe';

@Component({
  selector: 'app-wallet-list',
  standalone: true,
  imports: [CommonModule, XofPipe, PhoneFormatPipe],
  templateUrl: './wallet-list.component.html',
  styleUrl: './wallet-list.component.css'
})
export class WalletListComponent implements OnInit {
  wallets: Wallet[] = [];

  page = 0;
  size = 10;
  totalPages = 0;
  totalElements = 0;

  loading = false;
  errorMessage = '';

  constructor(private walletApiService: WalletApiService) {}

  ngOnInit(): void {
    this.loadWallets();
  }

  loadWallets(): void {
    this.loading = true;
    this.errorMessage = '';

    this.walletApiService.getWallets(this.page, this.size).subscribe({
      next: response => {
        this.wallets = response.content;
        this.totalPages = response.totalPages;
        this.totalElements = response.totalElements;
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Impossible de charger les portefeuilles.';
        this.loading = false;
      }
    });
  }

  nextPage(): void {
    if (this.page + 1 < this.totalPages) {
      this.page++;
      this.loadWallets();
    }
  }

  previousPage(): void {
    if (this.page > 0) {
      this.page--;
      this.loadWallets();
    }
  }
}