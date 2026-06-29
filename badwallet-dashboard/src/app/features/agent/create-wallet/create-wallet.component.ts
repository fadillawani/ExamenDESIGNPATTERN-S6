import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import {
  WalletApiService,
  CreateWalletRequest
} from '../../../core/services/wallet-api.service';

@Component({
  selector: 'app-create-wallet',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './create-wallet.component.html',
  styleUrl: './create-wallet.component.css'
})
export class CreateWalletComponent {

  loading = false;
  successMessage = '';
  errorMessage = '';

  walletForm!: FormGroup;

  constructor(
    private fb: FormBuilder,
    private walletApiService: WalletApiService
  ) {

    this.walletForm = this.fb.group({
      phoneNumber: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      initialBalance: [0, [Validators.required, Validators.min(0)]],
      code: [this.generateWalletCode(), Validators.required],
      currency: ['XOF', Validators.required]
    });
    

  }

  submit(): void {

    if (this.walletForm.invalid) {
      this.walletForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.successMessage = '';
    this.errorMessage = '';

    const payload: CreateWalletRequest = this.walletForm.value;

    this.walletApiService.createWallet(payload).subscribe({

      next: () => {

        this.successMessage = 'Portefeuille créé avec succès.';

        this.walletForm.reset({
          phoneNumber: '',
          email: '',
          initialBalance: 0,
          code: this.generateWalletCode(),
          currency: 'XOF'
        });

        this.loading = false;
      },

      error: () => {

        this.errorMessage = 'Impossible de créer le portefeuille.';
        this.loading = false;

      }

    });

  }
  generateWalletCode(): string {
  const timestamp = Date.now().toString().slice(-6);
  return `WLT-${timestamp}`;
  }

}