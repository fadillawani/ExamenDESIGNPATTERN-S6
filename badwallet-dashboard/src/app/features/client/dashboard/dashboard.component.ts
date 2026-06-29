import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { BalanceStoreService } from '../../../core/stores/balance-store.service';
import { XofPipe } from '../../../shared/pipes/xof.pipe';
import { PhoneFormatPipe } from '../../../shared/pipes/phone-format.pipe';
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, XofPipe, PhoneFormatPipe],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent {
  balanceForm!: FormGroup;
  loading = false;
  errorMessage = '';

  incomeChart: Chart | null = null;
  expenseChart: Chart | null = null;

  constructor(
    private fb: FormBuilder,
    public balanceStore: BalanceStoreService
  ) {
    this.balanceForm = this.fb.group({
      phoneNumber: ['', Validators.required]
    });
  }

  searchBalance(): void {
    if (this.balanceForm.invalid) {
      this.balanceForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';

    const phone = this.balanceForm.value.phoneNumber.replace(/\s+/g, '');

    this.balanceStore.refresh(phone);

    setTimeout(() => {
      this.createCharts();
      this.loading = false;
    }, 300);
  }

  createCharts(): void {
    this.incomeChart?.destroy();
    this.expenseChart?.destroy();

    this.incomeChart = new Chart('incomeChart', {
      type: 'bar',
      data: {
        labels: ['Dépôts', 'Transferts reçus'],
        datasets: [{
          label: 'Revenus',
          data: [50000, 25000]
        }]
      }
    });

    this.expenseChart = new Chart('expenseChart', {
      type: 'doughnut',
      data: {
        labels: ['Retraits', 'Transferts', 'Factures'],
        datasets: [{
          label: 'Dépenses',
          data: [10000, 8000, 7000]
        }]
      }
    });
  }
}