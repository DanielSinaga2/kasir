import 'package:flutter/material.dart';
import '../models/tarif_model.dart';
import '../models/transaksi_model.dart';
import '../services/transaksi_service.dart';

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
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchTarif();
  }

  Future<void> fetchTarif() async {
    try {
      final data = await TransaksiService.getTarif();
      setState(() {
        tarifList = data;
        loadingTarif = false;
      });
    } catch (e) {
      loadingTarif = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Input Data Pasien',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loadingTarif
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            )
          : Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _inputText('Nama Pasien', namaController),
                            const SizedBox(height: 16),
                            _inputText('Umur', umurController,
                                isNumber: true),
                            const SizedBox(height: 16),
                            _inputText(
                                'Nomor Rekam Medis', rmController),
                            const SizedBox(height: 16),
                            _dropdownField(
                              'Jenis Kelamin',
                              jenisKelamin,
                              ['Laki-laki', 'Perempuan'],
                              (v) => setState(() => jenisKelamin = v),
                            ),
                            const SizedBox(height: 16),
                            _dropdownTarif(),
                            const SizedBox(height: 16),
                            _tarifField(),
                            const SizedBox(height: 16),
                            _dropdownField(
                              'Metode Pembayaran',
                              metodePembayaran,
                              ['Lunas', 'Transfer', 'BPJS', 'Pending'],
                              (v) =>
                                  setState(() => metodePembayaran = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : _simpanData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'SIMPAN DATA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ===== DROPDOWN TARIF =====
  Widget _dropdownTarif() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          child: const Text(
            'Layanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Tarif>(
              value: selectedTarif,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: Colors.blueGrey[700]),
              hint: const Text(
                'Pilih Layanan',
                style: TextStyle(color: Colors.grey),
              ),
              items: tarifList.map((tarif) {
                return DropdownMenuItem<Tarif>(
                  value: tarif,
                  child: Text(
                    tarif.namaTarif,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  selectedTarif = val;
                  tarifController.text = val.harga.toStringAsFixed(0);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ===== TARIF FIELD =====
  Widget _tarifField() {
    return TextFormField(
      controller: tarifController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Tarif',
        labelStyle: const TextStyle(color: Colors.black87),
        prefixText: 'Rp ',
        prefixStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B5E20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B5E20),
      ),
    );
  }

  // ===== INPUT TEXT =====
  Widget _inputText(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:
              BorderSide(color: Colors.blueGrey[600]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (v) => v!.isEmpty ? '$label wajib diisi' : null,
    );
  }

  // ===== DROPDOWN FIELD =====
  Widget _dropdownField(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: Colors.blueGrey[700]),
              hint: Text(
                'Pilih $label',
                style: const TextStyle(color: Colors.grey),
              ),
              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ===== SIMPAN DATA KE BACKEND =====
  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      if (selectedTarif == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih layanan terlebih dahulu'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (metodePembayaran == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih metode pembayaran'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() => isSaving = true);

      try {
        // Buat transaksi baru
        final transaksi = Transaksi(
          id: 0,
          noInvoice: '',
          namaPasien: namaController.text,
          noRekamMedis: rmController.text,
          jenisKelamin: jenisKelamin,
          metodePembayaran: metodePembayaran!,
          totalHarga: selectedTarif!.harga,
          details: [
            TransaksiDetail(
              id: 0,
              transaksiID: 0,
              tarifID: selectedTarif!.id,
              namaLayanan: selectedTarif!.namaTarif,
              harga: selectedTarif!.harga,
            ),
          ],
          createdAt: DateTime.now(),
        );

        // Kirim ke backend
        final result = await TransaksiService.createTransaksi(transaksi);

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result['message']} - Invoice: ${result['invoice']}'),
            backgroundColor: Colors.green[800],
            duration: const Duration(seconds: 2),
          ),
        );

        // Tunggu sebentar agar snackbar terlihat, lalu kembali ke dashboard
        await Future.delayed(const Duration(seconds: 2));
        
        // Kembali ke halaman dashboard
        Navigator.pop(context);
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
        setState(() => isSaving = false);
      }
    }
  }
}