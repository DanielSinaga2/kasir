import 'package:flutter/material.dart';
import '../models/layanan.dart';

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
  Layanan? selectedLayanan;

  final List<Layanan> layananList = [
    Layanan(id: 1, nama: 'IGD', tarif: 150000),
    Layanan(id: 2, nama: 'Rawat Jalan', tarif: 75000),
    Layanan(id: 3, nama: 'Laboratorium', tarif: 200000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data Pasien'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Data Pasien',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _inputText('Nama Pasien', namaController,
                          icon: Icons.person_outline),
                      _inputText('Umur', umurController,
                          isNumber: true, icon: Icons.calendar_today),
                      _inputText('Nomor Rekam Medis', rmController,
                          icon: Icons.medical_information),
                      const SizedBox(height: 12),
                      _dropdownField(
                        'Jenis Kelamin',
                        jenisKelamin,
                        ['Laki-laki', 'Perempuan'],
                        Icons.transgender,
                        (value) => jenisKelamin = value,
                      ),
                      const SizedBox(height: 12),
                      _dropdownLayanan(),
                      const SizedBox(height: 12),
                      _tarifField(),
                      const SizedBox(height: 12),
                      _dropdownField(
                        'Metode Pembayaran',
                        metodePembayaran,
                        ['Lunas', 'Transfer', 'BPJS', 'Pending'],
                        Icons.payment,
                        (value) => metodePembayaran = value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'SIMPAN DATA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputText(String label, TextEditingController c,
      {bool isNumber = false, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
        ),
        validator: (v) => v!.isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }

  Widget _dropdownField(String label, String? value, List<String> items,
      IconData icon, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Pilih $label' : null,
    );
  }

  Widget _dropdownLayanan() {
    return DropdownButtonFormField<Layanan>(
      value: selectedLayanan,
      decoration: InputDecoration(
        labelText: 'Layanan',
        prefixIcon: const Icon(Icons.medical_services, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
      ),
      items: layananList.map((layanan) {
        return DropdownMenuItem(
          value: layanan,
          child: Text(layanan.nama),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          selectedLayanan = val;
          tarifController.text = val?.tarif.toString() ?? '';
        });
      },
      validator: (v) => v == null ? 'Pilih layanan' : null,
    );
  }

  Widget _tarifField() {
    return TextFormField(
      controller: tarifController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Tarif',
        prefixIcon: const Icon(Icons.attach_money, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
      ),
    );
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data pasien berhasil disimpan'),
          backgroundColor: Colors.blue.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}