class Tarif {
  final int id;
  final String namaTarif;
  final String kategori;
  final double harga;

  Tarif({
    required this.id,
    required this.namaTarif,
    required this.kategori,
    required this.harga,
  });

  factory Tarif.fromJson(Map<String, dynamic> json) {
    return Tarif(
      id: json['id'] is int ? json['id'] : 0,
      namaTarif: json['nama_tarif']?.toString() ?? '-',
      kategori: json['kategori']?.toString() ?? '-',
      harga: (json['harga'] ?? 0).toDouble(),
    );
  }
}
