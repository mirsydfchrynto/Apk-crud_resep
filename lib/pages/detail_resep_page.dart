// lib/pages/detail_resep_page.dart
import 'package:flutter/material.dart';
import '../db/pembantu_db.dart';
import '../models/resep.dart';

class DetailResepPage extends StatefulWidget {
  final int resepId;
  const DetailResepPage({super.key, required this.resepId});

  @override
  State<DetailResepPage> createState() => _DetailResepPageState();
}

class _DetailResepPageState extends State<DetailResepPage> {
  Future<Resep?>? _futureResep;

  @override
  void initState() {
    super.initState();
    _futureResep = PembantuDB.instan.bacaResep(widget.resepId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resep')),
      body: FutureBuilder<Resep?>(
        future: _futureResep,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final r = snap.data;
          if (r == null) return const Center(child: Text('Resep tidak ditemukan'));
          final daftarBahan = r.bahan.split('\n');
          final daftarLangkah = r.langkah.split('\n');
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(r.judul, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(r.deskripsi),
                const SizedBox(height: 16),
                const Text('Bahan-bahan', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...daftarBahan.map((e) => ListTile(leading: const Icon(Icons.circle, size: 8), title: Text(e))).toList(),
                const SizedBox(height: 16),
                const Text('Cara Masak', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...daftarLangkah.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  return ListTile(leading: CircleAvatar(child: Text('$idx')), title: Text(entry.value));
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
