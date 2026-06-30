import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  String selectedUnite = '';

  String formatXof(double value) {
    return NumberFormat.currency(
      locale: 'fr_SN',
      symbol: 'F CFA',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<WalletProvider>().loadBills();
    });
  }

  Future<void> payBills() async {
    final provider = context.read<WalletProvider>();
    final success = await provider.paySelectedBills();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Factures payées avec succès.'
              : provider.error ?? 'Erreur de paiement.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Factures',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () => provider.loadBills(unite: selectedUnite),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
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
                  'Portefeuille',
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
                  'Code : ${provider.phoneNumber == null ? '' : provider.walletCodeFromPhone(provider.phoneNumber!)}',
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
                _ProviderChip(
                  label: 'Tous',
                  selected: selectedUnite == '',
                  onTap: () {
                    setState(() => selectedUnite = '');
                    provider.loadBills();
                  },
                ),
                _ProviderChip(
                  label: 'ISM',
                  selected: selectedUnite == 'ISM',
                  onTap: () {
                    setState(() => selectedUnite = 'ISM');
                    provider.loadBills(unite: 'ISM');
                  },
                ),
                _ProviderChip(
                  label: 'WOYAFAL',
                  selected: selectedUnite == 'WOYAFAL',
                  onTap: () {
                    setState(() => selectedUnite = 'WOYAFAL');
                    provider.loadBills(unite: 'WOYAFAL');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          if (provider.loading)
            const Center(child: CircularProgressIndicator())
          else if (provider.bills.isEmpty)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text('Aucune facture impayée disponible.'),
            )
          else
            ...provider.bills.map((bill) {
              final selected =
                  provider.selectedBillReferences.contains(bill.reference);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: CheckboxListTile(
                  value: selected,
                  onChanged: (_) =>
                      provider.toggleBillSelection(bill.reference),
                  title: Text(
                    bill.reference,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    '${bill.serviceName} • ${bill.unite}\nÉchéance : ${bill.dueDate}',
                  ),
                  secondary: Text(
                    formatXof(bill.amount),
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            }),

          const SizedBox(height: 20),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: provider.loading ||
                      provider.selectedBillReferences.isEmpty
                  ? null
                  : payBills,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Payer les factures sélectionnées',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ProviderChip({
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
          fontWeight: FontWeight.w800,
          color: selected ? Colors.black : Colors.grey.shade700,
        ),
      ),
    );
  }
}