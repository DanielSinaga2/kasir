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
    // Cek field ID dalam berbagai kemungkinan
    int parseId() {
      // Coba berbagai format field name
      if (json.containsKey('ID')) {
        return json['ID'] is int ? json['ID'] : int.tryParse(json['ID'].toString()) ?? 0;
      }
      if (json.containsKey('id')) {
        return json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0;
      }
      if (json.containsKey('Id')) {
        return json['Id'] is int ? json['Id'] : int.tryParse(json['Id'].toString()) ?? 0;
      }
      return 0;
    }

    return Tarif(
      id: parseId(),
      namaTarif: json['nama_tarif']?.toString() ?? json['namaTarif']?.toString() ?? '-',
      kategori: json['kategori']?.toString() ?? '-',
      harga: (json['harga'] ?? 0).toDouble(),
    );
  }
}