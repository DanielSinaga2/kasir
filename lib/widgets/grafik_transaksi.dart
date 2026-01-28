import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaksi_model.dart';

class GrafikTransaksi extends StatelessWidget {
  final List<Transaksi> transaksiList;

  const GrafikTransaksi({super.key, required this.transaksiList});

  @override
  Widget build(BuildContext context) {
    // Group transaksi per hari (7 hari terakhir)
    final Map<String, double> dataHarian = _groupByDay();
    final List<MapEntry<String, double>> sortedData = dataHarian.entries.toList();

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
              'Tren Transaksi 7 Hari Terakhir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: Rp ${_totalPendapatan().toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval(dataHarian),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < sortedData.length) {
                            final label = sortedData[value.toInt()].key;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              )
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % _calculateInterval(dataHarian) == 0) {
                            return Text(
                              'Rp${(value ~/ 1000).toInt()}k',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: sortedData.length.toDouble() - 1,
                  minY: 0,
                  maxY: _maxValue(dataHarian) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildSpots(sortedData),
                      isCurved: true,
                      color: Colors.blueGrey[800]!,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueGrey.withOpacity(0.15),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blueGrey.withOpacity(0.3),
                            Colors.blueGrey.withOpacity(0.05),
                          ],
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey[800]!,
                          Colors.blueGrey[600]!,
                        ],
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey[800]!,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final index = touchedSpot.spotIndex;
                          final day = sortedData[index].key;
                          final value = sortedData[index].value;
                          return LineTooltipItem(
                            '$day\nRp ${value.toStringAsFixed(0)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Pendapatan Harian',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _maxValue(Map<String, double> data) {
    if (data.isEmpty) return 100000;
    return data.values.reduce((max, current) => current > max ? current : max);
  }

  double _totalPendapatan() {
    return transaksiList.fold(0, (sum, transaksi) => sum + transaksi.totalHarga);
  }

  double _calculateInterval(Map<String, double> data) {
    final maxValue = _maxValue(data);
    if (maxValue <= 50000) return 10000;
    if (maxValue <= 200000) return 50000;
    if (maxValue <= 500000) return 100000;
    if (maxValue <= 1000000) return 200000;
    return 500000;
  }

  Map<String, double> _groupByDay() {
    final Map<String, double> result = {};
    final now = DateTime.now();
    
    // Daftar nama hari
    final List<String> hariList = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    
    // Inisialisasi 7 hari terakhir dengan nilai 0
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayIndex = date.weekday % 7; // 0 = Minggu, 1 = Senin, dst
      final key = hariList[dayIndex];
      result[key] = 0;
    }

    // Isi dengan data transaksi
    for (final transaksi in transaksiList) {
      final transaksiDate = transaksi.createdAt;
      final daysDiff = now.difference(transaksiDate).inDays;
      
      if (daysDiff <= 6) {
        final dayIndex = transaksiDate.weekday % 7;
        final key = hariList[dayIndex];
        result[key] = (result[key] ?? 0) + transaksi.totalHarga;
      }
    }

    return result;
  }

  List<FlSpot> _buildSpots(List<MapEntry<String, double>> data) {
    final List<FlSpot> spots = [];
    
    for (int i = 0; i < data.length; i++) {
      final value = data[i].value;
      spots.add(FlSpot(i.toDouble(), value));
    }
    
    return spots;
  }
}