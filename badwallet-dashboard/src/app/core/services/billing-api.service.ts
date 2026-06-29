import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Bill } from '../models/bill.model';

@Injectable({
  providedIn: 'root'
})
export class BillingApiService {
  private readonly BASE_URL = 'http://localhost:8080/api/external/factures';

  constructor(private http: HttpClient) {}

  getCurrentBills(walletCode: string, unite?: string): Observable<Bill[]> {
    let params = new HttpParams();

    if (unite) {
      params = params.set('unite', unite);
    }

    return this.http.get<Bill[]>(`${this.BASE_URL}/${walletCode}/current`, { params });
  }
} 