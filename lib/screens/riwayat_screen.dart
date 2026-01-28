import 'package:flutter/material.dart';
import '../models/transaksi_model.dart';
import '../services/transaksi_service.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<Transaksi> transaksiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final data = await TransaksiService.getRiwayatTransaksi();
      setState(() {
        transaksiList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transaksiList.isEmpty
              ? const Center(child: Text('Belum ada transaksi'))
              : RefreshIndicator(
                  onRefresh: fetchRiwayat,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transaksiList.length,
                    itemBuilder: (context, index) {
                      final transaksi = transaksiList[index];
                      return _buildTransaksiCard(transaksi);
                    },
                  ),
                ),
    );
  }

  Widget _buildTransaksiCard(Transaksi transaksi) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaksi.noInvoice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(
                    'Rp ${transaksi.totalHarga.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green[800],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Nama: ${transaksi.namaPasien}'),
            Text('No RM: ${transaksi.noRekamMedis}'),
            if (transaksi.jenisKelamin != null)
              Text('Jenis Kelamin: ${transaksi.jenisKelamin}'),
            Text('Metode: ${transaksi.metodePembayaran}'),
            const SizedBox(height: 12),
            const Text(
              'Layanan:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            ...transaksi.details.map(
              (detail) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• ${detail.namaLayanan} - Rp ${detail.harga.toStringAsFixed(0)}'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tanggal: ${transaksi.createdAt.toLocal().toString().split('.')[0]}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}