export interface Bill {
  id: number;
  reference: string;
  walletCode: string;
  serviceName: string;
  unite: string;
  amount: number;
  dueDate: string;
  paid: boolean;
}