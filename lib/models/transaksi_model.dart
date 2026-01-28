class Transaksi {
  final int id;
  final String noInvoice;
  final String namaPasien;
  final String noRekamMedis;
  final String? jenisKelamin;
  final String metodePembayaran;
  final double totalHarga;
  final List<TransaksiDetail> details;
  final DateTime createdAt;

  Transaksi({
    required this.id,
    required this.noInvoice,
    required this.namaPasien,
    required this.noRekamMedis,
    this.jenisKelamin,
    required this.metodePembayaran,
    required this.totalHarga,
    required this.details,
    required this.createdAt,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['ID'] ?? json['id'] ?? 0,
      noInvoice: json['no_invoice'] ?? '',
      namaPasien: json['nama_pasien'] ?? '',
      noRekamMedis: json['no_rekam_medis'] ?? '',
      jenisKelamin: json['jenis_kelamin'],
      metodePembayaran: json['metode_pembayaran'] ?? '',
      totalHarga: (json['total_harga'] ?? 0).toDouble(),
      details: (json['details'] as List?)
              ?.map((detail) => TransaksiDetail.fromJson(detail))
              .toList() ??
          [],
      createdAt: json['CreatedAt'] != null 
          ? DateTime.parse(json['CreatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_pasien': namaPasien,
      'no_rekam_medis': noRekamMedis,
      'jenis_kelamin': jenisKelamin,
      'metode_pembayaran': metodePembayaran,
      'layanan_ids': details.map((detail) => detail.tarifID).toList(),
    };
  }
}

class TransaksiDetail {
  final int id;
  final int transaksiID;
  final int tarifID;
  final String namaLayanan;
  final double harga;

  TransaksiDetail({
    required this.id,
    required this.transaksiID,
    required this.tarifID,
    required this.namaLayanan,
    required this.harga,
  });

  factory TransaksiDetail.fromJson(Map<String, dynamic> json) {
    return TransaksiDetail(
      id: json['ID'] ?? json['id'] ?? 0,
      transaksiID: json['transaksi_id'] ?? 0,
      tarifID: json['tarif_id'] ?? 0,
      namaLayanan: json['nama_layanan'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
    );
  }
}