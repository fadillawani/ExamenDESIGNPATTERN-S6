import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'features/auth/login_screen.dart';
import 'features/dashboard/home_screen.dart';
import 'features/transfers/transfer_screen.dart';
import 'features/history/history_screen.dart';
import 'providers/wallet_provider.dart';

void main() {
  runApp(const BadWalletApp());
}

class BadWalletApp extends StatelessWidget {
  const BadWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BadWallet Mobile',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F6F8),
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF22C55E),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/transfer': (_) => const TransferScreen(),
          '/history': (_) => const HistoryScreen(),
        },
      ),
    );
  }
}