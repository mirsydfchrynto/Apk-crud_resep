// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/masuk_page.dart';
import 'pages/daftar_page.dart';
import 'pages/daftar_resep_page.dart';

void main() {
  runApp(const AplikasiResep());
}

class AplikasiResep extends StatelessWidget {
  const AplikasiResep({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Resep (CRUD)',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/masuk',
      routes: {
        '/masuk': (_) => const MasukPage(),
        '/daftar': (_) => const DaftarPage(),
        '/home': (_) => const DaftarResepPage(),
      },
    );
  }
}
