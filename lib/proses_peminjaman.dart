import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uts_2301082020/peminjaman.dart';
import 'package:intl/intl.dart';

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

  final TextEditingController _jumlahPinjamanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String formatRupiah(double number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  String _formatNumber(String s) {
    return NumberFormat.decimalPattern('id').format(
      int.parse(s.replaceAll(RegExp(r'[^0-9]'), '')),
    );
  }

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
              decoration: const InputDecoration(
                labelText: 'Tanggal',
                hintText: 'DD/MM/YYYY',
              ),
              controller: _tanggalController,
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                LengthLimitingTextInputFormatter(10),
                _DateInputFormatter(),
              ],
              onSaved: (value) => tanggal = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap isi tanggal';
                }
                if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                  return 'Format tanggal harus DD/MM/YYYY';
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
              decoration: const InputDecoration(
                labelText: 'Jumlah Pinjaman',
                prefixText: 'Rp',
              ),
              keyboardType: TextInputType.number,
              controller: _jumlahPinjamanController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) {
                    return newValue.copyWith(text: '');
                  }
                  return newValue.copyWith(
                    text: _formatNumber(newValue.text),
                    selection: TextSelection.collapsed(offset: _formatNumber(newValue.text).length),
                  );
                }),
              ],
              onSaved: (value) => jumlahPinjaman = int.parse(value!.replaceAll('.', '')),
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
              Text('Angsuran Pokok: ${formatRupiah(peminjaman.angsuranPokok)}'),
              Text('Bunga per Bulan: ${formatRupiah(peminjaman.bungaPerBulan)}'),
              Text('Angsuran per Bulan: ${formatRupiah(peminjaman.angsuranPerBulan)}'),
              Text('Total Hutang: ${formatRupiah(peminjaman.totalHutang)}'),
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

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (newText.length > oldValue.text.length) {
      if (newText.length == 2 || newText.length == 5) {
        return TextEditingValue(
          text: '$newText/',
          selection: TextSelection.collapsed(offset: newText.length + 1),
        );
      }
    }
    return newValue;
  }
}
