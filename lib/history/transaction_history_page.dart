import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi")),
      body: const Center(
        child: Text("List transaksi kasir (next step)"),
      ),
    );
  }
}
