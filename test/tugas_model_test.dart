import 'package:flutter_test/flutter_test.dart';
import 'package:pm_tugas_07/tugas_model.dart';

void main() {
  late TugasModel m;

  setUp(() => m = TugasModel());

  void isi(String judul) => m.tambah(
        judul: judul,
        mataKuliah: 'Pemrograman Mobile',
        tenggat: DateTime(2026, 11, 20),
      );

  test('tambah menambah tugas dan memberi notifikasi', () {
    var notifikasi = 0;
    m.addListener(() => notifikasi++);
    isi('Laporan');
    expect(m.total, 1);
    expect(m.jumlahAktif, 1);
    expect(notifikasi, 1);
  });

  test('tandaiSelesai mengubah jumlah dan persentase', () {
    isi('A');
    isi('B');
    m.tandaiSelesai(m.daftar.first.id);
    expect(m.jumlahSelesai, 1);
    expect(m.jumlahAktif, 1);
    expect(m.persenSelesai, 50);
  });

  test('hapus menghilangkan tugas', () {
    isi('A');
    m.hapus(m.daftar.first.id);
    expect(m.total, 0);
  });

  test('persentase 0 saat daftar kosong', () {
    expect(m.persenSelesai, 0);
  });
}