class Layanan {
  final int id;
  final String nama;
  final double tarif;

  Layanan({
    required this.id,
    required this.nama,
    required this.tarif,
  });

  factory Layanan.fromJson(Map<String, dynamic> json) {
    return Layanan(
      id: json['id'],
      nama: json['nama_tarif'],
      tarif: (json['harga'] as num).toDouble(),
    );
  }
}
