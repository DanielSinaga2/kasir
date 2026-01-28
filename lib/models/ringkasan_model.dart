class RingkasanPemasukan {
  final double totalUang;
  final int totalTransaksi;

  RingkasanPemasukan({
    required this.totalUang,
    required this.totalTransaksi,
  });

  factory RingkasanPemasukan.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return RingkasanPemasukan(
      totalUang: (data['total_uang'] ?? 0).toDouble(),
      totalTransaksi: data['total_transaksi'] ?? 0,
    );
  }
}
