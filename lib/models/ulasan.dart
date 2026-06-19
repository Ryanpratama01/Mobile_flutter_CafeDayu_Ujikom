class Ulasan {
  final int? id;
  final int cafeId;      // ulasan ini punya cafe yang mana
  final int userId;      // ulasan ini dari user yang mana
  final String namaUser; // disimpan langsung biar gampang ditampilkan
  final double rating;   // 1.0 - 5.0
  final String komentar;
  final String tag;      // contoh: "Nugasable", "Estetik", dll
  final String tanggal;

  Ulasan({
    this.id,
    required this.cafeId,
    required this.userId,
    required this.namaUser,
    required this.rating,
    required this.komentar,
    required this.tag,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cafeId': cafeId,
      'userId': userId,
      'namaUser': namaUser,
      'rating': rating,
      'komentar': komentar,
      'tag': tag,
      'tanggal': tanggal,
    };
  }

  factory Ulasan.fromMap(Map<String, dynamic> map) {
    return Ulasan(
      id: map['id'],
      cafeId: map['cafeId'],
      userId: map['userId'],
      namaUser: map['namaUser'],
      rating: map['rating'],
      komentar: map['komentar'],
      tag: map['tag'],
      tanggal: map['tanggal'],
    );
  }
}