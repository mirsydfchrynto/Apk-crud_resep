// lib/pages/masuk_page.dart
import 'package:flutter/material.dart';
import '../db/pembantu_db.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});
  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final _kontrolEmail = TextEditingController();
  final _kontrolSandi = TextEditingController();
  final _kunciForm = GlobalKey<FormState>();
  bool _memproses = false;

  Future<void> _masuk() async {
    if (!_kunciForm.currentState!.validate()) return;
    setState(() => _memproses = true);
    final pengguna = await PembantuDB.instan.dapatkanPenggunaDenganEmail(_kontrolEmail.text.trim());
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _memproses = false);

    if (pengguna == null || pengguna['sandi'] != _kontrolSandi.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email atau sandi salah')));
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _kunciForm,
          child: Column(children: [
            TextFormField(controller: _kontrolEmail, decoration: const InputDecoration(labelText: 'Email'), validator: (v)=> (v==null||v.isEmpty)?'Email diperlukan':null),
            const SizedBox(height: 12),
            TextFormField(controller: _kontrolSandi, decoration: const InputDecoration(labelText: 'Sandi'), obscureText: true, validator: (v)=> (v==null||v.isEmpty)?'Sandi diperlukan':null),
            const SizedBox(height: 20),
            _memproses ? const CircularProgressIndicator() : ElevatedButton(onPressed: _masuk, child: const Text('Masuk')),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/daftar'), child: const Text('Belum punya akun? Daftar'))
          ]),
        ),
      ),
    );
  }
}
