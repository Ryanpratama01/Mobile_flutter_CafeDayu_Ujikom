class Cafe {
  final int? id;
  final String nama;
  final String alamat;
  final double latitude;
  final double longitude;
  final String jamBuka;
  final String kisaranHarga;
  final List<String> label; // contoh: ["Estetik", "Nongkrong", "Nugasable"]
  final double rating;
  final String deskripsi;
  final String? fotoUrl;

  Cafe({
    this.id,
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.jamBuka,
    required this.kisaranHarga,
    required this.label,
    required this.rating,
    required this.deskripsi,
    this.fotoUrl,
  });

  // Untuk simpan ke database (SQLite hanya terima tipe data primitif)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'jamBuka': jamBuka,
      'kisaranHarga': kisaranHarga,
      'label': label.join(','), // list diubah jadi string dipisah koma
      'rating': rating,
      'deskripsi': deskripsi,
      'fotoUrl': fotoUrl,
    };
  }

  // Untuk ambil data dari database, diubah balik jadi object Cafe
  factory Cafe.fromMap(Map<String, dynamic> map) {
    return Cafe(
      id: map['id'],
      nama: map['nama'],
      alamat: map['alamat'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      jamBuka: map['jamBuka'],
      kisaranHarga: map['kisaranHarga'],
      label: (map['label'] as String).split(','),
      rating: map['rating'],
      deskripsi: map['deskripsi'],
      fotoUrl: map['fotoUrl'],
    );
  }
}