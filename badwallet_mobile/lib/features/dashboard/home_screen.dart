import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/wallet_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hideBalance = false;

  String formatXof(double value) {
    return NumberFormat.currency(
      locale: 'fr_SN',
      symbol: 'XOF',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final balance = provider.balance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BadWallet'),
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.phoneNumber ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hideBalance
                              ? '••••••••'
                              : formatXof(balance?.balance ?? 0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            hideBalance = !hideBalance;
                          });
                        },
                        icon: Icon(
                          hideBalance
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.send,
                  label: 'Transférer',
                  onTap: () => Navigator.pushNamed(context, '/transfer'),
                ),
                _ActionButton(
                  icon: Icons.receipt_long,
                  label: 'Payer',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.history,
                  label: 'Historique',
                  onTap: () => Navigator.pushNamed(context, '/history'),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text(
              'Dernières transactions',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            const SizedBox(height: 12),
            ...provider.transactions.take(5).map((transaction) {
              final isIncome = transaction.type.contains('DEPOSIT') ||
                  transaction.type.contains('TRANSFER_IN');

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isIncome ? Colors.green.shade100 : Colors.red.shade100,
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(transaction.type),
                  subtitle: Text(transaction.createdAt),
                  trailing: Text(
                    formatXof(transaction.amount),
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF22C55E)),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}