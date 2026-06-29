import { Routes } from '@angular/router';
import { MainLayoutComponent } from './shared/layout/main-layout/main-layout.component';

export const routes: Routes = [
  {
    path: '',
    component: MainLayoutComponent,
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      {
        path: 'dashboard',
        loadComponent: () => import('./features/client/dashboard/dashboard.component')
          .then(m => m.DashboardComponent)
      },
      {
        path: 'transactions',
        loadComponent: () => import('./features/transactions/transaction-history/transaction-history.component')
          .then(m => m.TransactionHistoryComponent)
      },
      {
        path: 'transfer',
        loadComponent: () => import('./features/client/transfer/transfer.component')
          .then(m => m.TransferComponent)
      },
      {
        path: 'bills',
        loadComponent: () => import('./features/bills/current-bills/current-bills.component')
          .then(m => m.CurrentBillsComponent)
      },
      {
        path: 'admin/wallets',
        loadComponent: () => import('./features/agent/wallet-list/wallet-list.component')
          .then(m => m.WalletListComponent)
      },
      {
        path: 'admin/create-wallet',
        loadComponent: () => import('./features/agent/create-wallet/create-wallet.component')
          .then(m => m.CreateWalletComponent)
      },
      {
        path: 'admin/search-wallet',
        loadComponent: () => import('./features/agent/search-wallet/search-wallet.component')
          .then(m => m.SearchWalletComponent)
      },
      {
        path: 'admin/deposit-withdraw',
        loadComponent: () => import('./features/agent/deposit-withdraw/deposit-withdraw.component')
          .then(m => m.DepositWithdrawComponent)
      }
    ]
  }
];