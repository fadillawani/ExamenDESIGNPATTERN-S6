import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { WalletApiService } from '../../../core/services/wallet-api.service';
import { Wallet } from '../../../core/models/wallet.model';
import { XofPipe } from '../../../shared/pipes/xof.pipe';
import { PhoneFormatPipe } from '../../../shared/pipes/phone-format.pipe';
import { RouterLink } from '@angular/router';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';


@Component({
  selector: 'app-wallet-list',
  standalone: true,
imports: [CommonModule, ReactiveFormsModule, RouterLink, XofPipe, PhoneFormatPipe],  templateUrl: './wallet-list.component.html',
  styleUrl: './wallet-list.component.css',
})
export class WalletListComponent implements OnInit {
  wallets: Wallet[] = [];

  page = 0;
  size = 10;
  totalPages = 0;
  totalElements = 0;

  loading = false;
  errorMessage = '';
  searchForm!: FormGroup;
  searchedWallet: Wallet | null = null;

  constructor(
  private walletApiService: WalletApiService,
  private fb: FormBuilder
) {
  this.searchForm = this.fb.group({
    phoneNumber: ['', Validators.required]
  });
}

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
  searchWallet(): void {
  if (this.searchForm.invalid) {
    this.searchForm.markAllAsTouched();
    return;
  }

  this.loading = true;
  this.errorMessage = '';
  this.searchedWallet = null;

 const phone = this.normalizePhone(this.searchForm.value.phoneNumber);

  this.walletApiService.getWalletByPhone(phone).subscribe({
    next: wallet => {
      this.searchedWallet = wallet;
      this.wallets = [wallet];
      this.totalElements = 1;
      this.totalPages = 1;
      this.page = 0;
      this.loading = false;
    },
    error: () => {
      this.errorMessage = 'Aucun portefeuille trouvé pour ce numéro.';
      this.wallets = [];
      this.loading = false;
    }
  });
}

resetSearch(): void {
  this.searchForm.reset();
  this.searchedWallet = null;
  this.page = 0;
  this.loadWallets();
}
normalizePhone(phone: string): string {
  return phone.replace(/\s+/g, '');
}
}