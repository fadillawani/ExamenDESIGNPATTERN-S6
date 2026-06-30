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
      symbol: 'F CFA',
      decimalDigits: 0,
    ).format(value);
  }

  bool isIncome(String type) {
    return type.contains('DEPOSIT') || type.contains('TRANSFER_IN');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final balance = provider.balance;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'BadWallet',
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mon portefeuille',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider.phoneNumber ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hideBalance
                              ? '••••••••'
                              : formatXof(balance?.balance ?? 0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => hideBalance = !hideBalance);
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

            const SizedBox(height: 24),

            Row(
              children: [
                _ActionButton(
                  icon: Icons.send_rounded,
                  label: 'Transférer',
                  onTap: () => Navigator.pushNamed(context, '/transfer'),
                ),
                _ActionButton(
                  icon: Icons.receipt_long_rounded,
                  label: 'Payer',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.history_rounded,
                  label: 'Historique',
                  onTap: () => Navigator.pushNamed(context, '/history'),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dernières transactions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/history'),
                  child: const Text('Voir tout'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (provider.transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text('Aucune transaction disponible.'),
              )
            else
              ...provider.transactions.take(5).map((transaction) {
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
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(transaction.createdAt),
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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF22C55E), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}