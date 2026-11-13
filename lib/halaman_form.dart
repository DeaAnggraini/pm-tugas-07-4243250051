import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

class HalamanForm extends StatefulWidget {
  const HalamanForm({super.key});

  @override
  State<HalamanForm> createState() => _HalamanFormState();
}

class _HalamanFormState extends State<HalamanForm> {
  final _kunci = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  DateTime? _tenggat;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController();
    _mataKuliah = TextEditingController();
  }

  @override
  void dispose() {
    _judul.dispose();
    _mataKuliah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tenggat ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (!mounted) return; // widget bisa saja sudah ditutup setelah await
    if (hasil != null) setState(() => _tenggat = hasil);
  }

  void _simpan() {
    if (!_kunci.currentState!.validate()) return;
    final tenggat = _tenggat;
    if (tenggat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tenggat terlebih dahulu')),
      );
      return;
    }
    context.read<TugasModel>().tambah(
          judul: _judul.text.trim(),
          mataKuliah: _mataKuliah.text.trim(),
          tenggat: tenggat,
        );
    context.pop(); // kembali ke daftar
  }

  String? _wajib(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Form(
        key: _kunci,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(labelText: 'Judul tugas'),
              validator: _wajib,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mataKuliah,
              decoration: const InputDecoration(labelText: 'Mata kuliah'),
              validator: _wajib,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.event),
              label: Text(_tenggat == null
                  ? 'Pilih tenggat'
                  : 'Tenggat: ${formatTanggal(_tenggat!)}'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}