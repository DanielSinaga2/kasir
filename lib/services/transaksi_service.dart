import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarif_model.dart';
import '../models/transaksi_model.dart';
import '../models/ringkasan_model.dart'; // Tambahkan ini

class TransaksiService {
  static const String baseUrl =
      "https://cedrick-unlunated-gwyn.ngrok-free.app/api";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Ambil data tarif dari backend
  static Future<List<Tarif>> getTarif() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kasir/tarif'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Tarif.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data tarif');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // Simpan transaksi ke backend
  static Future<Map<String, dynamic>> createTransaksi(Transaksi transaksi) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kasir/transaksi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(transaksi.toJson()),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Gagal menyimpan transaksi');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // Ambil riwayat transaksi dari backend
  static Future<List<Transaksi>> getRiwayatTransaksi() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kasir/riwayat'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaksi.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil riwayat transaksi');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // TAMBAHKAN: Ambil ringkasan pemasukan dari backend
  static Future<RingkasanPemasukan> getRingkasanPemasukan() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kasir/pemasukan'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RingkasanPemasukan.fromJson(data);
      } else {
        throw Exception('Gagal mengambil ringkasan pemasukan');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}