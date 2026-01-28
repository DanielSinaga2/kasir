import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarif_model.dart';

class TarifService {
  static const String baseUrl =
      "https://cedrick-unlunated-gwyn.ngrok-free.app/api";

  static Future<List<Tarif>> fetchTarifKasir() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/kasir/tarif'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Tarif.fromJson(e)).toList();
    } else {
      throw Exception(
          'Gagal mengambil data tarif (${response.statusCode})');
    }
  }
}
