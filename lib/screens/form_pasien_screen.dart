import 'package:flutter/material.dart';
import '../models/tarif_model.dart';
import '../services/tarif_service.dart';

class FormPasienScreen extends StatefulWidget {
  const FormPasienScreen({super.key});

  @override
  State<FormPasienScreen> createState() => _FormPasienScreenState();
}

class _FormPasienScreenState extends State<FormPasienScreen> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final rmController = TextEditingController();
  final tarifController = TextEditingController();

  String? jenisKelamin;
  String? metodePembayaran;

  Tarif? selectedTarif;
  List<Tarif> tarifList = [];
  bool loadingTarif = true;

  @override
  void initState() {
    super.initState();
    fetchTarif();
  }

  Future<void> fetchTarif() async {
    try {
      final data = await TarifService.fetchTarifKasir();
      setState(() {
        tarifList = data;
        loadingTarif = false;
      });
    } catch (e) {
      loadingTarif = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data Pasien'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: loadingTarif
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _inputText('Nama Pasien', namaController),
                    _inputText('Umur', umurController, isNumber: true),
                    _inputText('Nomor Rekam Medis', rmController),

                    _dropdownField(
                      'Jenis Kelamin',
                      jenisKelamin,
                      ['Laki-laki', 'Perempuan'],
                      (v) => setState(() => jenisKelamin = v),
                    ),

                    _dropdownTarif(),
                    _tarifField(),

                    _dropdownField(
                      'Metode Pembayaran',
                      metodePembayaran,
                      ['Lunas', 'Transfer', 'BPJS', 'Pending'],
                      (v) => setState(() => metodePembayaran = v),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _simpanData,
                        child: const Text('SIMPAN DATA'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ===== DROPDOWN TARIF =====
  Widget _dropdownTarif() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<Tarif>(
        value: selectedTarif,
        decoration: const InputDecoration(
          labelText: 'Layanan',
          border: OutlineInputBorder(),
        ),
        items: tarifList.map((tarif) {
          return DropdownMenuItem(
            value: tarif,
            child: Text(tarif.namaTarif),
          );
        }).toList(),
        onChanged: (val) {
          if (val == null) return;
          setState(() {
            selectedTarif = val;
            tarifController.text = val.harga.toStringAsFixed(0);
          });
        },
        validator: (v) => v == null ? 'Pilih layanan' : null,
      ),
    );
  }

  // ===== TARIF =====
  Widget _tarifField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: tarifController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Tarif',
          prefixText: 'Rp ',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // ===== INPUT =====
  Widget _inputText(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }

  // ===== DROPDOWN UMUM =====
  Widget _dropdownField(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Pilih $label' : null,
      ),
    );
  }

  // ===== SIMPAN =====
  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pasien berhasil disimpan')),
      );
      Navigator.pop(context);
    }
  }
}
