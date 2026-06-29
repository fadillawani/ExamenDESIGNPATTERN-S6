import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { PageResponse, Wallet } from '../models/wallet.model';

@Injectable({
  providedIn: 'root'
})
export class WalletApiService {
  private readonly BASE_URL = 'http://localhost:8080/api/wallets';

  constructor(private http: HttpClient) {}

  getWallets(page: number, size: number): Observable<PageResponse<Wallet>> {
    const params = new HttpParams()
      .set('page', page)
      .set('size', size);

    return this.http.get<PageResponse<Wallet>>(this.BASE_URL, { params });
  }
}