import 'package:flutter/material.dart';
import 'package:kasir/screens/form_pasien_screen.dart';
import 'package:kasir/screens/riwayat_screen.dart';
import 'package:kasir/services/transaksi_service.dart';
import 'package:kasir/widgets/grafik_transaksi.dart';
import 'package:kasir/widgets/statistik_card.dart';
import 'package:kasir/models/transaksi_model.dart';
import 'package:kasir/models/ringkasan_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<dynamic>> _futureData;
  List<Transaksi> _transaksiList = [];
  RingkasanPemasukan? _ringkasan;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future<List<dynamic>> _loadData() async {
    try {
      final transaksi = await TransaksiService.getRiwayatTransaksi();
      final ringkasan = await TransaksiService.getRingkasanPemasukan();
      
      setState(() {
        _transaksiList = transaksi;
        _ringkasan = ringkasan;
      });
      
      return [transaksi, ringkasan];
    } catch (e) {
      throw Exception('Gagal memuat data: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureData = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Kasir',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Gagal memuat data dashboard'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800],
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistik Cards
                  if (_ringkasan != null)
                    StatistikCard(ringkasan: _ringkasan!),
                  const SizedBox(height: 20),

                  // Grafik Transaksi
                  if (_transaksiList.isNotEmpty)
                    GrafikTransaksi(transaksiList: _transaksiList),
                  const SizedBox(height: 20),

                  // Jika belum ada transaksi, tampilkan placeholder
                  if (_transaksiList.isEmpty)
                    _buildPlaceholderGrafik(),
                  
                  // Menu Utama
                  const Text(
                    'Menu Utama',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_add,
                        title: 'Input Pasien',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FormPasienScreen()),
                          ).then((_) => _refreshData());
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.history,
                        title: 'Riwayat',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RiwayatScreen()),
                          );
                        },
                      ),
                      // Hanya 2 menu: Input Pasien dan Riwayat
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Info Footer
                  Card(
                    elevation: 1,
                    color: Colors.blueGrey[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.blueGrey[700], size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Dashboard akan otomatis diperbarui setelah input data',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderGrafik() {
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
            const Text(
              'Pendapatan 7 Hari Terakhir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: Rp 0',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada data transaksi',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mulai dengan input data pasien',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}