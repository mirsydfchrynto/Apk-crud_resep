// lib/pages/form_resep_page.dart
import 'package:flutter/material.dart';
import '../models/resep.dart';
import '../db/pembantu_db.dart';

class FormResepPage extends StatefulWidget {
  final Resep? resep;
  const FormResepPage({super.key, this.resep});

  @override
  State<FormResepPage> createState() => _FormResepPageState();
}

class _FormResepPageState extends State<FormResepPage> {
  final _kunciForm = GlobalKey<FormState>();
  final _kontrolJudul = TextEditingController();
  final _kontrolDeskripsi = TextEditingController();
  final _kontrolBahan = TextEditingController();
  final _kontrolLangkah = TextEditingController();
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    if (widget.resep != null) {
      _kontrolJudul.text = widget.resep!.judul;
      _kontrolDeskripsi.text = widget.resep!.deskripsi;
      _kontrolBahan.text = widget.resep!.bahan;
      _kontrolLangkah.text = widget.resep!.langkah;
    }
  }

  Future<void> _simpan() async {
    if (!_kunciForm.currentState!.validate()) return;
    setState(() => _menyimpan = true);
    final sekarang = DateTime.now().toIso8601String();
    if (widget.resep == null) {
      final baru = Resep(
        judul: _kontrolJudul.text.trim(),
        deskripsi: _kontrolDeskripsi.text.trim(),
        bahan: _kontrolBahan.text.trim(),
        langkah: _kontrolLangkah.text.trim(),
        dibuatPada: sekarang,
      );
      await PembantuDB.instan.buatResep(baru);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resep disimpan')));
    } else {
      final ubah = widget.resep!.salinDengan(
        judul: _kontrolJudul.text.trim(),
        deskripsi: _kontrolDeskripsi.text.trim(),
        bahan: _kontrolBahan.text.trim(),
        langkah: _kontrolLangkah.text.trim(),
        dibuatPada: sekarang,
      );
      await PembantuDB.instan.ubahResep(ubah);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resep diperbarui')));
    }
    setState(() => _menyimpan = false);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _kontrolJudul.dispose();
    _kontrolDeskripsi.dispose();
    _kontrolBahan.dispose();
    _kontrolLangkah.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sedangUbah = widget.resep != null;
    return Scaffold(
      appBar: AppBar(title: Text(sedangUbah ? 'Ubah Resep' : 'Tambah Resep')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _kunciForm,
          child: ListView(children: [
            TextFormField(controller: _kontrolJudul, decoration: const InputDecoration(labelText: 'Judul'), validator: (v)=> (v==null||v.isEmpty)?'Judul diperlukan':null),
            const SizedBox(height: 12),
            TextFormField(controller: _kontrolDeskripsi, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 2),
            const SizedBox(height: 12),
            TextFormField(controller: _kontrolBahan, decoration: const InputDecoration(labelText: 'Bahan-bahan (pisahkan baris baru)'), maxLines: 6, validator: (v)=> (v==null||v.isEmpty)?'Bahan diperlukan':null),
            const SizedBox(height: 12),
            TextFormField(controller: _kontrolLangkah, decoration: const InputDecoration(labelText: 'Cara Masak (pisahkan baris baru)'), maxLines: 8, validator: (v)=> (v==null||v.isEmpty)?'Cara masak diperlukan':null),
            const SizedBox(height: 20),
            _menyimpan ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: _simpan, child: Text(sedangUbah ? 'Simpan Perubahan' : 'Simpan'))
          ]),
        ),
      ),
    );
  }
}
