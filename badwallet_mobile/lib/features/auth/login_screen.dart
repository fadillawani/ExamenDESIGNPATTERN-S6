import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/wallet_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController(
    text: '+221770000003',
  );

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> continueToApp() async {
    final provider = context.read<WalletProvider>();
    final success = await provider.loadWallet(phoneController.text);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Erreur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'BW',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Bienvenue sur BadWallet',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Saisissez votre numéro pour accéder à votre portefeuille.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  hintText: '+221770000003',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: provider.loading ? null : continueToApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: provider.loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Continuer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}