class Peminjaman {
  final int kode;
  final String nama;
  final String tanggal;
  final int kodePeminjam;
  final int kodeNasabah;
  final String namaNasabah;
  final int jumlahPinjaman;
  final int lamaPinjaman;
  final double bunga;

  Peminjaman({
    required this.kode,
    required this.nama,
    required this.tanggal,
    required this.kodePeminjam,
    required this.kodeNasabah,
    required this.namaNasabah,
    required this.jumlahPinjaman,
    required this.lamaPinjaman,
    required this.bunga,
  });

  double get angsuranPokok => jumlahPinjaman / lamaPinjaman;
  double get bungaPerBulan => jumlahPinjaman * 0.12 / 12;
  double get angsuranPerBulan => bungaPerBulan + angsuranPokok;
  double get totalHutang => jumlahPinjaman + (jumlahPinjaman * bunga / 100);
}
