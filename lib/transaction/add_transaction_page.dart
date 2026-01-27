import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final pasienController = TextEditingController();
  final nominalController = TextEditingController();
  final catatanController = TextEditingController();

  String layanan = "IGD";
  String metodePembayaran = "Tunai";
  String status = "Lunas";

  final List<String> layananList = [
    "IGD",
    "Rawat Jalan",
    "Rawat Inap",
  ];

  final List<String> metodeList = [
    "Tunai",
    "Transfer",
    "BPJS",
    "Asuransi",
  ];

  final List<String> statusList = [
    "Lunas",
    "Pending",
  ];

  void simpanTransaksi() {
    if (_formKey.currentState!.validate()) {
      // sementara tampilkan dialog sukses
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Transaksi Berhasil"),
          content: const Text("Data transaksi berhasil disimpan"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // kembali ke dashboard
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // 🔜 STEP 4: kirim ke backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Transaksi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Pasien
              TextFormField(
                controller: pasienController,
                decoration: const InputDecoration(
                  labelText: "Nama Pasien",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama pasien wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Jenis Layanan
              DropdownButtonFormField(
                value: layanan,
                items: layananList
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => layanan = value!);
                },
                decoration: const InputDecoration(
                  labelText: "Jenis Layanan",
                  prefixIcon: Icon(Icons.local_hospital),
                ),
              ),
              const SizedBox(height: 16),

              // Metode Pembayaran
              DropdownButtonFormField(
                value: metodePembayaran,
                items: metodeList
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => metodePembayaran = value!);
                },
                decoration: const InputDecoration(
                  labelText: "Metode Pembayaran",
                  prefixIcon: Icon(Icons.payment),
                ),
              ),
              const SizedBox(height: 16),

              // Nominal
              TextFormField(
                controller: nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal Pembayaran",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nominal wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField(
                value: status,
                items: statusList
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => status = value!);
                },
                decoration: const InputDecoration(
                  labelText: "Status Pembayaran",
                  prefixIcon: Icon(Icons.check_circle),
                ),
              ),
              const SizedBox(height: 16),

              // Catatan
              TextFormField(
                controller: catatanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Catatan (Opsional)",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 32),

              // Button Simpan
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("SIMPAN TRANSAKSI"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: simpanTransaksi,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
