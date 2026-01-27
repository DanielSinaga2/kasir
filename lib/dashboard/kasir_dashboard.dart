import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import '../transaction/add_transaction_page.dart';
import '../history/transaction_history_page.dart';

class KasirDashboard extends StatelessWidget {
  const KasirDashboard({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Kasir"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD INFO
            Row(
              children: [
                _infoCard(
                  title: "Transaksi Hari Ini",
                  value: "12",
                  icon: Icons.receipt_long,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                _infoCard(
                  title: "Pendapatan",
                  value: "Rp 3.500.000",
                  icon: Icons.payments,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ACTION BUTTON
            _menuButton(
              context,
              title: "Tambah Transaksi",
              icon: Icons.add_circle,
              color: Colors.blueAccent,
              page: const AddTransactionPage(),
            ),
            const SizedBox(height: 12),
            _menuButton(
              context,
              title: "Riwayat Transaksi",
              icon: Icons.history,
              color: Colors.orange,
              page: const TransactionHistoryPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
