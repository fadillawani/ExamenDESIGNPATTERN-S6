import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool loading = false;

  String formatXof(double value) {
    return NumberFormat.currency(
      locale: 'fr_SN',
      symbol: 'F CFA',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  void dispose() {
    receiverController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> submitTransfer() async {
    final provider = context.read<WalletProvider>();
    final receiverPhone = receiverController.text.replaceAll(' ', '');
    final amount = double.tryParse(amountController.text);

    if (receiverPhone.isEmpty || amount == null || amount <= 0) {
      showMessage('Veuillez saisir un numéro et un montant valide.');
      return;
    }

    if (receiverPhone == provider.phoneNumber) {
      showMessage('Le destinataire doit être différent de l’expéditeur.');
      return;
    }

    setState(() => loading = true);

    final success = await provider.transfer(
      receiverPhone: receiverPhone,
      amount: amount,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
      showMessage('Transfert effectué avec succès.');
      receiverController.clear();
      amountController.clear();
      Navigator.pop(context);
    } else {
      showMessage(provider.error ?? 'Erreur lors du transfert.');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget keypadButton(String value) {
    return InkWell(
      onTap: () {
        setState(() {
          amountController.text += value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final amount = double.tryParse(amountController.text) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Transférer',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
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
                  'Depuis',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  provider.phoneNumber ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Montant à envoyer',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  amount <= 0 ? '0 F CFA' : formatXof(amount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          TextField(
            controller: receiverController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Numéro destinataire',
              hintText: '+221770000002',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: amountController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Montant',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    setState(() {
                      amountController.text = amountController.text
                          .substring(0, amountController.text.length - 1);
                    });
                  }
                },
                icon: const Icon(Icons.backspace_outlined),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              for (final value in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
                keypadButton(value),
              keypadButton('0'),
              keypadButton('00'),
              InkWell(
                onTap: () {
                  setState(() {
                    amountController.clear();
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'C',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: loading ? null : submitTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Confirmer le transfert',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}