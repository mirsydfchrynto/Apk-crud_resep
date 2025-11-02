// lib/models/resep.dart
class Resep {
  final int? id;
  final String judul;
  final String deskripsi;
  final String bahan; // setiap bahan pisah baris dengan \n
  final String langkah; // setiap langkah pisah baris dengan \n
  final String dibuatPada;

  Resep({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.bahan,
    required this.langkah,
    required this.dibuatPada,
  });

  factory Resep.dariMap(Map<String, dynamic> json) => Resep(
        id: json['id'] as int?,
        judul: json['judul'] as String,
        deskripsi: json['deskripsi'] as String,
        bahan: json['bahan'] as String,
        langkah: json['langkah'] as String,
        dibuatPada: json['dibuatPada'] as String,
      );

  Map<String, dynamic> keMap() {
    final map = <String, dynamic>{
      'judul': judul,
      'deskripsi': deskripsi,
      'bahan': bahan,
      'langkah': langkah,
      'dibuatPada': dibuatPada,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Resep salinDengan({
    int? id,
    String? judul,
    String? deskripsi,
    String? bahan,
    String? langkah,
    String? dibuatPada,
  }) {
    return Resep(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      bahan: bahan ?? this.bahan,
      langkah: langkah ?? this.langkah,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}
