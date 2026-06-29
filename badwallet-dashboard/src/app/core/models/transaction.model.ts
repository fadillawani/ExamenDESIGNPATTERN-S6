export interface WalletTransaction {
  id: number;
  type: string;
  amount: number;
  fees: number;
  createdAt: string;
}