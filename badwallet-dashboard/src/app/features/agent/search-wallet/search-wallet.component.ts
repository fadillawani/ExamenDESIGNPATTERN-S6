import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { WalletApiService } from '../../../core/services/wallet-api.service';
import { Wallet } from '../../../core/models/wallet.model';
import { XofPipe } from '../../../shared/pipes/xof.pipe';
import { PhoneFormatPipe } from '../../../shared/pipes/phone-format.pipe';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-search-wallet',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, ReactiveFormsModule, XofPipe, PhoneFormatPipe],
  templateUrl: './search-wallet.component.html',
  styleUrl: './search-wallet.component.css'
})
export class SearchWalletComponent {
  searchForm!: FormGroup;
  searchedWallet: Wallet | null = null;

  wallet: Wallet | null = null;
  loading = false;
  errorMessage = '';

  constructor(
  private walletApiService: WalletApiService,
  private fb: FormBuilder
) {
  this.searchForm = this.fb.group({
    phoneNumber: ['', Validators.required]
  });
}

  search(): void {
    if (this.searchForm.invalid) {
      this.searchForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';
    this.wallet = null;

    const phone = this.searchForm.value.phoneNumber;

    this.walletApiService.getWalletByPhone(phone).subscribe({
      next: response => {
        this.wallet = response;
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Aucun portefeuille trouvé pour ce numéro.';
        this.loading = false;
      }
    });
  }
  
  
}