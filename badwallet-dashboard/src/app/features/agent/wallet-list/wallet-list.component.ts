import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import { RouterLink } from '@angular/router';

import { WalletApiService } from '../../../core/services/wallet-api.service';
import { Wallet } from '../../../core/models/wallet.model';
import { XofPipe } from '../../../shared/pipes/xof.pipe';
import { PhoneFormatPipe } from '../../../shared/pipes/phone-format.pipe';

@Component({
  selector: 'app-wallet-list',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    RouterLink,
    XofPipe,
    PhoneFormatPipe
  ],
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

  searchForm!: FormGroup;

  selectedWallet: Wallet | null = null;
  operationType: 'DEPOSIT' | 'WITHDRAW' | null = null;
  operationAmount = 0;
  operationMessage = '';

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

  searchWallet(): void {
    if (this.searchForm.invalid) {
      this.searchForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';

    const phone = this.normalizePhone(this.searchForm.value.phoneNumber);

    this.walletApiService.getWalletByPhone(phone).subscribe({
      next: wallet => {
        this.wallets = [wallet];
        this.totalElements = 1;
        this.totalPages = 1;
        this.page = 0;
        this.loading = false;
      },
      error: () => {
        this.wallets = [];
        this.errorMessage = 'Aucun portefeuille trouvé pour ce numéro.';
        this.loading = false;
      }
    });
  }

  resetSearch(): void {
    this.searchForm.reset();
    this.page = 0;
    this.errorMessage = '';
    this.loadWallets();
  }

  normalizePhone(phone: string): string {
    return phone.replace(/\s+/g, '');
  }

  openOperation(wallet: Wallet, type: 'DEPOSIT' | 'WITHDRAW'): void {
    this.selectedWallet = wallet;
    this.operationType = type;
    this.operationAmount = 0;
    this.operationMessage = '';
  }

  cancelOperation(): void {
    this.selectedWallet = null;
    this.operationType = null;
    this.operationAmount = 0;
    this.operationMessage = '';
  }

  confirmOperation(): void {
    if (!this.selectedWallet || !this.operationType || this.operationAmount <= 0) {
      this.operationMessage = 'Veuillez saisir un montant valide.';
      return;
    }

    this.loading = true;
    this.operationMessage = '';

    if (this.operationType === 'DEPOSIT') {
      this.walletApiService.deposit(this.selectedWallet.id, {
        amount: this.operationAmount,
        paymentMethod: 'CREDIT_CARD'
      }).subscribe({
        next: () => {
          this.cancelOperation();
          this.loadWallets();
        },
        error: () => {
          this.operationMessage = 'Erreur lors du dépôt.';
          this.loading = false;
        }
      });
    }

    if (this.operationType === 'WITHDRAW') {
      this.walletApiService.withdraw({
        phoneNumber: this.selectedWallet.phoneNumber,
        amount: this.operationAmount
      }).subscribe({
        next: () => {
          this.cancelOperation();
          this.loadWallets();
        },
        error: () => {
          this.operationMessage = 'Erreur lors du retrait.';
          this.loading = false;
        }
      });
    }
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