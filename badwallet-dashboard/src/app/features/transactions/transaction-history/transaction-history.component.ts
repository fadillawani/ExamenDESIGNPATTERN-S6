import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

import { WalletApiService } from '../../../core/services/wallet-api.service';
import { WalletTransaction } from '../../../core/models/transaction.model';
import { XofPipe } from '../../../shared/pipes/xof.pipe';

@Component({
  selector: 'app-transaction-history',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, XofPipe],
  templateUrl: './transaction-history.component.html',
  styleUrl: './transaction-history.component.css'
})
export class TransactionHistoryComponent {
  filterForm!: FormGroup;

  transactions: WalletTransaction[] = [];
  filteredTransactions: WalletTransaction[] = [];

  loading = false;
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private walletApiService: WalletApiService
  ) {
    this.filterForm = this.fb.group({
      phoneNumber: ['', Validators.required],
      type: ['']
    });
  }

  loadTransactions(): void {
    if (this.filterForm.invalid) {
      this.filterForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';

    const phone = this.filterForm.value.phoneNumber.replace(/\s+/g, '');

    this.walletApiService.getTransactions(phone).subscribe({
      next: response => {
        this.transactions = response;
        this.applyFilter();
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Impossible de charger les transactions.';
        this.loading = false;
      }
    });
  }

  applyFilter(): void {
    const type = this.filterForm.value.type;

    this.filteredTransactions = type
      ? this.transactions.filter(transaction => transaction.type === type)
      : this.transactions;
  }
}