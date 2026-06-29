import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  AbstractControl,
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  ValidationErrors,
  Validators
} from '@angular/forms';

import { WalletApiService } from '../../../core/services/wallet-api.service';
import { BalanceStoreService } from '../../../core/stores/balance-store.service';

@Component({
  selector: 'app-transfer',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './transfer.component.html',
  styleUrl: './transfer.component.css'
})
export class TransferComponent {
  transferForm!: FormGroup;

  loading = false;
  successMessage = '';
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private walletApiService: WalletApiService,
    private balanceStore: BalanceStoreService
  ) {
    this.transferForm = this.fb.group(
      {
        senderPhone: ['', Validators.required],
        receiverPhone: ['', Validators.required],
        amount: [null, [Validators.required, Validators.min(1)]]
      },
      { validators: this.differentPhonesValidator }
    );
  }

  differentPhonesValidator(control: AbstractControl): ValidationErrors | null {
    const sender = control.get('senderPhone')?.value?.replace(/\s+/g, '');
    const receiver = control.get('receiverPhone')?.value?.replace(/\s+/g, '');

    if (sender && receiver && sender === receiver) {
      return { samePhone: true };
    }

    return null;
  }

  submit(): void {
    if (this.transferForm.invalid) {
      this.transferForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.successMessage = '';
    this.errorMessage = '';

    const payload = {
      senderPhone: this.normalizePhone(this.transferForm.value.senderPhone),
      receiverPhone: this.normalizePhone(this.transferForm.value.receiverPhone),
      amount: Number(this.transferForm.value.amount)
    };

    this.walletApiService.transfer(payload).subscribe({
      next: () => {
        this.successMessage = 'Transfert effectué avec succès.';
        this.balanceStore.refresh(payload.senderPhone);
        this.transferForm.reset();
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Erreur lors du transfert. Vérifiez le solde ou le numéro destinataire.';
        this.loading = false;
      }
    });
  }

  normalizePhone(phone: string): string {
    return phone.replace(/\s+/g, '');
  }
}