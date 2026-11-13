import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

enum FilterTugas { semua, aktif, selesai }

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  FilterTugas _filter = FilterTugas.semua; // state lokal

  String _label(FilterTugas f) => switch (f) {
        FilterTugas.semua => 'Semua',
        FilterTugas.aktif => 'Aktif',
        FilterTugas.selesai => 'Selesai',
      };

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TugasModel>();
    final tampil = model.daftar
        .where((t) => switch (_filter) {
              FilterTugas.semua => true,
              FilterTugas.aktif => !t.selesai,
              FilterTugas.selesai => t.selesai,
            })
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Planner Tugas Kuliah')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                for (final f in FilterTugas.values)
                  FilterChip(
                    label: Text(_label(f)),
                    selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
              ],
            ),
          ),
          Expanded(
            child: tampil.isEmpty
                ? const Center(child: Text('Tidak ada tugas'))
                : ListView.separated(
                    itemCount: tampil.length,
                    separatorBuilder: (context, i) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final t = tampil[i];
                      return ListTile(
                        leading: Checkbox(
                          value: t.selesai,
                          onChanged: (v) => context
                              .read<TugasModel>()
                              .tandaiSelesai(t.id, selesai: v ?? false),
                        ),
                        title: Text(
                          t.judul,
                          style: t.selesai
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough)
                              : null,
                        ),
                        subtitle: Text(
                            '${t.mataKuliah} · ${formatTanggal(t.tenggat)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              context.read<TugasModel>().hapus(t.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}