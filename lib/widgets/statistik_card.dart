import 'package:flutter/material.dart';
import '../models/ringkasan_model.dart';

class StatistikCard extends StatelessWidget {
  final RingkasanPemasukan ringkasan;

  const StatistikCard({super.key, required this.ringkasan});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Pendapatan',
            value: 'Rp ${_formatNumber(ringkasan.totalUang)}',
            icon: Icons.monetization_on,
            color: Colors.green[800]!,
            backgroundColor: Colors.green.withOpacity(0.1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Total Transaksi',
            value: ringkasan.totalTransaksi.toString(),
            icon: Icons.receipt,
            color: Colors.blueGrey[800]!,
            backgroundColor: Colors.blueGrey.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}JT';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}RB';
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}