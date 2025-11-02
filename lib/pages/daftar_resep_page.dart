// lib/pages/daftar_resep_page.dart
import 'package:flutter/material.dart';
import '../db/pembantu_db.dart';
import '../models/resep.dart';
import 'form_resep_page.dart';
import 'detail_resep_page.dart';

class DaftarResepPage extends StatefulWidget {
  const DaftarResepPage({super.key});
  @override
  State<DaftarResepPage> createState() => _DaftarResepPageState();
}

class _DaftarResepPageState extends State<DaftarResepPage> {
  late Future<List<Resep>> _daftarFuture;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  void _muat() {
    _daftarFuture = PembantuDB.instan.bacaSemuaResep();
  }

  Future<void> _refresh() async {
    setState(() => _muat());
  }

  @override
  Widget build(BuildContext context) {
    _muat();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Resep')),
      body: FutureBuilder<List<Resep>>(
        future: _daftarFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final list = snap.data ?? [];
          if (list.isEmpty) return const Center(child: Text('Belum ada resep. Tekan + untuk tambah.'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final r = list[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(r.judul),
                    subtitle: Text(r.deskripsi, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailResepPage(resepId: r.id!)));
                      _refresh();
                    },
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => FormResepPage(resep: r)));
                          _refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus resep?'),
                              content: const Text('Yakin ingin menghapus resep ini?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
                                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Hapus')),
                              ],
                            ),
                          );
                          if (ok == true) {
                            await PembantuDB.instan.hapusResep(r.id!);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resep dihapus')));
                            _refresh();
                          }
                        },
                      ),
                    ]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FormResepPage()));
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
