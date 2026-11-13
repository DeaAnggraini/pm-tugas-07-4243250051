import 'package:flutter/foundation.dart';

String formatTanggal(DateTime d) => '${d.day}/${d.month}/${d.year}';

class TugasKuliah {
  const TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.selesai = false,
  });

  final int id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;
  final bool selesai;

  TugasKuliah copyWith({bool? selesai}) => TugasKuliah(
        id: id,
        judul: judul,
        mataKuliah: mataKuliah,
        tenggat: tenggat,
        selesai: selesai ?? this.selesai,
      );
}

class TugasModel extends ChangeNotifier {
  final List<TugasKuliah> _daftar = [];
  int _idBerikut = 1;

  List<TugasKuliah> get daftar => List.unmodifiable(_daftar);
  int get total => _daftar.length;
  int get jumlahSelesai => _daftar.where((t) => t.selesai).length;
  int get jumlahAktif => total - jumlahSelesai;
  double get persenSelesai => total == 0 ? 0 : jumlahSelesai / total * 100;

  void tambah({
    required String judul,
    required String mataKuliah,
    required DateTime tenggat,
  }) {
    _daftar.add(TugasKuliah(
      id: _idBerikut++,
      judul: judul,
      mataKuliah: mataKuliah,
      tenggat: tenggat,
    ));
    notifyListeners();
  }

  void tandaiSelesai(int id, {bool selesai = true}) {
    final i = _daftar.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _daftar[i] = _daftar[i].copyWith(selesai: selesai);
    notifyListeners();
  }

  void hapus(int id) {
    _daftar.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}