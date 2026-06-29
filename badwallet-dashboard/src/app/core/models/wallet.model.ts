export interface Wallet {
  id: number;
  phoneNumber: string;
  email: string;
  balance: number;
  code: string;
  currency: string;
}

export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  first: boolean;
  last: boolean;
}