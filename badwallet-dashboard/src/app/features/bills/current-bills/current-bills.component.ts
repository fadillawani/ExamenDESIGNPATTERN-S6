import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

import { BillingApiService } from '../../../core/services/billing-api.service';
import { WalletApiService } from '../../../core/services/wallet-api.service';
import { Bill } from '../../../core/models/bill.model';
import { XofPipe } from '../../../shared/pipes/xof.pipe';

@Component({
  selector: 'app-current-bills',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, XofPipe],
  templateUrl: './current-bills.component.html',
  styleUrl: './current-bills.component.css'
})
export class CurrentBillsComponent {
  searchForm!: FormGroup;

  bills: Bill[] = [];
  selectedReferences = new Set<string>();

  loading = false;
  successMessage = '';
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private billingApiService: BillingApiService,
    private walletApiService: WalletApiService
  ) {
    this.searchForm = this.fb.group({
      phoneNumber: ['', Validators.required],
      walletCode: ['', Validators.required],
      unite: ['']
    });
  }

  loadBills(): void {
    if (this.searchForm.invalid) {
      this.searchForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';
    this.successMessage = '';
    this.selectedReferences.clear();

    const walletCode = this.searchForm.value.walletCode;
    const unite = this.searchForm.value.unite || undefined;

    this.billingApiService.getCurrentBills(walletCode, unite).subscribe({
      next: response => {
        this.bills = response;
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Impossible de charger les factures.';
        this.loading = false;
      }
    });
  }

  toggleBill(reference: string, checked: boolean): void {
    if (checked) {
      this.selectedReferences.add(reference);
    } else {
      this.selectedReferences.delete(reference);
    }
  }

  paySelectedBills(): void {
    if (this.selectedReferences.size === 0) {
      this.errorMessage = 'Veuillez sélectionner au moins une facture.';
      return;
    }

    this.loading = true;
    this.errorMessage = '';
    this.successMessage = '';

    this.walletApiService.payFactures({
     phoneNumber: this.phoneFromWalletCode(this.searchForm.value.walletCode),
      serviceName: this.searchForm.value.unite || 'ISM',
      factureReferences: Array.from(this.selectedReferences)
    }).subscribe({
      next: () => {
        this.successMessage = 'Factures payées avec succès.';
        this.selectedReferences.clear();
        this.loadBills();
      },
      error: () => {
        this.errorMessage = 'Erreur lors du paiement des factures.';
        this.loading = false;
      }
    });
  }

  normalizePhone(phone: string): string {
    return phone.replace(/\s+/g, '');
  }
  phoneFromWalletCode(walletCode: string): string {
  const id = walletCode.replace('WLT-', '');
  return `+22177${id}`;
}
}