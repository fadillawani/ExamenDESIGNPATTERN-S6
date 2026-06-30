import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/wallet_transaction.dart';
import '../../providers/wallet_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'ALL';

  String formatXof(double value) {
    return NumberFormat.currency(
      locale: 'fr_SN',
      symbol: 'F CFA',
      decimalDigits: 0,
    ).format(value);
  }

  bool isIncome(String type) {
    return type.contains('DEPOSIT') || type.contains('TRANSFER_IN');
  }

  List<WalletTransaction> filteredTransactions(
    List<WalletTransaction> transactions,
  ) {
    if (selectedFilter == 'ALL') {
      return transactions;
    }

    if (selectedFilter == 'INCOME') {
      return transactions.where((t) => isIncome(t.type)).toList();
    }

    if (selectedFilter == 'EXPENSE') {
      return transactions.where((t) => !isIncome(t.type)).toList();
    }

    return transactions.where((t) => t.type == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final transactions = filteredTransactions(provider.transactions);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Historique',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: provider.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mouvements du compte',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.phoneNumber ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${provider.transactions.length} transactions',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChipButton(
                    label: 'Tout',
                    selected: selectedFilter == 'ALL',
                    onTap: () => setState(() => selectedFilter = 'ALL'),
                  ),
                  _FilterChipButton(
                    label: 'Entrées',
                    selected: selectedFilter == 'INCOME',
                    onTap: () => setState(() => selectedFilter = 'INCOME'),
                  ),
                  _FilterChipButton(
                    label: 'Sorties',
                    selected: selectedFilter == 'EXPENSE',
                    onTap: () => setState(() => selectedFilter = 'EXPENSE'),
                  ),
                  _FilterChipButton(
                    label: 'Dépôts',
                    selected: selectedFilter == 'DEPOSIT_CREDIT_CARD',
                    onTap: () =>
                        setState(() => selectedFilter = 'DEPOSIT_CREDIT_CARD'),
                  ),
                  _FilterChipButton(
                    label: 'Retraits',
                    selected: selectedFilter == 'WITHDRAW',
                    onTap: () => setState(() => selectedFilter = 'WITHDRAW'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text('Aucune transaction trouvée.'),
              )
            else
              ...transactions.map((transaction) {
                final income = isIncome(transaction.type);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          income ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        income
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: income ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      transaction.type,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      'Frais : ${formatXof(transaction.fees)}\n${transaction.createdAt}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      '${income ? '+' : '-'} ${formatXof(transaction.amount)}',
                      style: TextStyle(
                        color: income ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: const Color(0xFF22C55E),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.grey.shade700,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}