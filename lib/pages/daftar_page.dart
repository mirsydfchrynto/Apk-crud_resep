// lib/pages/daftar_page.dart
import 'package:flutter/material.dart';
import '../db/pembantu_db.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});
  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _kontrolNama = TextEditingController();
  final _kontrolEmail = TextEditingController();
  final _kontrolSandi = TextEditingController();
  final _kunciForm = GlobalKey<FormState>();
  bool _memproses = false;

  Future<void> _daftar() async {
    if (!_kunciForm.currentState!.validate()) return;
    setState(() => _memproses = true);
    final ada = await PembantuDB.instan.dapatkanPenggunaDenganEmail(_kontrolEmail.text.trim());
    if (ada != null) {
      setState(() => _memproses = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar')));
      return;
    }
    await PembantuDB.instan.buatPengguna(_kontrolNama.text.trim(), _kontrolEmail.text.trim(), _kontrolSandi.text);
    setState(() => _memproses = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi sukses')));
    Navigator.of(context).pushReplacementNamed('/masuk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _kunciForm,
          child: Column(children: [
            TextFormField(controller: _kontrolNama, decoration: const InputDecoration(labelText: 'Nama'), validator: (v)=> (v==null||v.isEmpty)?'Nama diperlukan':null),
            const SizedBox(height: 12),
            TextFormField(controller: _kontrolEmail, decoration: const InputDecoration(labelText: 'Email'), validator: (v)=> (v==null||v.isEmpty)?'Email diperlukan':null),
            const SizedBox(height: 12),
            TextFormField(controller: _kontrolSandi, decoration: const InputDecoration(labelText: 'Sandi'), obscureText: true, validator: (v)=> (v==null||v.isEmpty)?'Sandi diperlukan':null),
            const SizedBox(height: 20),
            _memproses ? const CircularProgressIndicator() : ElevatedButton(onPressed: _daftar, child: const Text('Daftar')),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/masuk'), child: const Text('Sudah punya akun? Masuk'))
          ]),
        ),
      ),
    );
  }
}
