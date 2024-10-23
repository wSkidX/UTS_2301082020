import 'package:flutter/material.dart';
import 'peminjaman.dart';

class ProsesPeminjamanPage extends StatefulWidget {
  const ProsesPeminjamanPage({Key? key}) : super(key: key);

  @override
  _ProsesPeminjamanPageState createState() => _ProsesPeminjamanPageState();
}

class _ProsesPeminjamanPageState extends State<ProsesPeminjamanPage> {
  final _formKey = GlobalKey<FormState>();
  late int kode;
  late String nama;
  late String tanggal;
  late int kodePeminjam;
  late int kodeNasabah;
  late String namaNasabah;
  late int jumlahPinjaman;
  late int lamaPinjaman;
  late double bunga;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses Peminjaman'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kode'),
              keyboardType: TextInputType.number,
              onSaved: (value) => kode = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi kode';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama'),
              onSaved: (value) => nama = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi nama';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Tanggal'),
              onSaved: (value) => tanggal = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi tanggal';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kode Peminjam'),
              keyboardType: TextInputType.number,
              onSaved: (value) => kodePeminjam = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi kode peminjam';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kode Nasabah'),
              keyboardType: TextInputType.number,
              onSaved: (value) => kodeNasabah = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi kode nasabah';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Nasabah'),
              onSaved: (value) => namaNasabah = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi nama nasabah';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Jumlah Pinjaman'),
              keyboardType: TextInputType.number,
              onSaved: (value) => jumlahPinjaman = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi jumlah pinjaman';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Lama Pinjaman (Bulan)'),
              keyboardType: TextInputType.number,
              onSaved: (value) => lamaPinjaman = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi lama pinjaman';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Bunga (%)'),
              keyboardType: TextInputType.number,
              onSaved: (value) => bunga = double.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi bunga';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final peminjaman = Peminjaman(
                    kode: kode,
                    nama: nama,
                    tanggal: tanggal,
                    kodePeminjam: kodePeminjam,
                    kodeNasabah: kodeNasabah,
                    namaNasabah: namaNasabah,
                    jumlahPinjaman: jumlahPinjaman,
                    lamaPinjaman: lamaPinjaman,
                    bunga: bunga,
                  );
                  _showHasilPerhitungan(peminjaman);
                }
              },
              child: const Text('Hitung'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHasilPerhitungan(Peminjaman peminjaman) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hasil Perhitungan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Angsuran Pokok: ${peminjaman.angsuranPokok.toStringAsFixed(2)}'),
              Text('Bunga per Bulan: ${peminjaman.bungaPerBulan.toStringAsFixed(2)}'),
              Text('Angsuran per Bulan: ${peminjaman.angsuranPerBulan.toStringAsFixed(2)}'),
              Text('Total Hutang: ${peminjaman.totalHutang.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
