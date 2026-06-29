import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { BalanceStoreService } from '../../../core/stores/balance-store.service';
import { XofPipe } from '../../pipes/xof.pipe';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [RouterLink,RouterLinkActive, XofPipe, CommonModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  constructor(public balanceStore: BalanceStoreService) {}
}