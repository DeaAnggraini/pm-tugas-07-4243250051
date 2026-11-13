import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<TugasModel>(); // ikut berubah otomatis
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(title: const Text('Jumlah total'), trailing: Text('${m.total}'))),
          Card(child: ListTile(title: const Text('Selesai'), trailing: Text('${m.jumlahSelesai}'))),
          Card(child: ListTile(title: const Text('Aktif'), trailing: Text('${m.jumlahAktif}'))),
          const SizedBox(height: 16),
          Text('Persentase selesai: ${m.persenSelesai.toStringAsFixed(0)}%'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: m.persenSelesai / 100),
        ],
      ),
    );
  }
}