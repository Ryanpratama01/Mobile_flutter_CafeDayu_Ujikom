import '../models/ulasan.dart';
import 'db_helper.dart';

class SeedUlasan {
  static Future<void> insertInitialUlasan() async {
    final db = DBHelper();
    final cafes = await db.getAllCafes();
    if (cafes.isEmpty) return;

    final existing = await db.getUlasanByCafe(cafes[0].id!);
    if (existing.isNotEmpty) return;

    final namaUser = [
      'Rizal A.', 'Fina N.', 'Damar P.', 'Ayu W.', 'Septi R.',
      'Bagas K.', 'Dinda S.', 'Aldi F.', 'Maya L.', 'Yoga T.',
      'Citra D.', 'Reza M.', 'Wulan H.', 'Fajar B.', 'Indah P.',
      'Bayu S.', 'Nadia K.', 'Galih W.', 'Putri A.', 'Eko H.',
      'Sari M.', 'Doni P.', 'Lestari N.', 'Hendra J.', 'Vina T.',
    ];

    final komentarByTag = {
      'Nugasable': [
        'Colokan banyak, wifi kencang, betah lama buat ngerjain tugas.',
        'Tempatnya tenang, cocok buat kerja remote seharian.',
        'Meja luas dan nyaman buat bawa laptop, recommended!',
        'Sering ke sini buat ngerjain skripsi, nyaman dan nggak berisik.',
        'AC dingin, wifi stabil, pas buat meeting online juga.',
        'Banyak spot deket colokan, jadi nggak rebutan sama yang lain.',
      ],
      'Nongkrong': [
        'Asik buat kumpul rame-rame sama temen, suasana nyaman.',
        'Pas banget buat nongkrong sore, harga juga ramah kantong.',
        'Tempat duduknya nyaman buat ngobrol lama.',
        'Sering reunian sama temen kuliah di sini, tempatnya luas.',
        'Live music di weekend bikin makin asik buat nongkrong.',
        'Area outdoor-nya enak buat ngobrol santai sambil ngopi.',
      ],
      'Estetik': [
        'View-nya bagus banget buat foto-foto, spot Instagramable.',
        'Desain interiornya unik, cocok buat konten media sosial.',
        'Tempatnya cantik, setiap sudut enak buat difoto.',
        'Pencahayaan natural-nya bagus banget pas sore hari.',
        'Dekorasinya kekinian, suka banget sama nuansa warmnya.',
        'Spot fotonya banyak banget, sayang kalau cuma sebentar di sini.',
      ],
      'Worth It': [
        'Harga sesuai sama kualitas, porsinya juga pas.',
        'Worth it banget buat budget mahasiswa.',
        'Harganya bersahabat, rasanya tetap enak.',
        'Promo weekday-nya lumayan bikin hemat.',
        'Dibanding tempat lain di Taman Dayu, ini paling worth it.',
        'Kualitas oke, harga nggak bikin kantong jebol.',
      ],
    };

    final now = DateTime.now();

    for (final cafe in cafes) {
      // jumlah ulasan proporsional sama rating, makin tinggi makin banyak (8-25 ulasan)
      final jumlahUlasan = (8 + (cafe.rating - 4.0) * 30).round().clamp(8, 25);

      for (int i = 0; i < jumlahUlasan; i++) {
        final tag = cafe.label[i % cafe.label.length];
        final komentarList = komentarByTag[tag] ?? ['Tempatnya bagus, recommended!'];
        final komentar = komentarList[i % komentarList.length];
        final nama = namaUser[(cafe.id! + i) % namaUser.length];
        final hariLalu = i + 1;
        final tanggalUlasan = now.subtract(Duration(days: hariLalu));

        // rating ulasan bervariasi di sekitar rating cafe, biar natural
        double ratingUlasan = cafe.rating + ((i % 5) - 2) * 0.2;
        ratingUlasan = ratingUlasan.clamp(3.5, 5.0);

        await db.insertUlasan(Ulasan(
          cafeId: cafe.id!,
          userId: 0,
          namaUser: nama,
          rating: double.parse(ratingUlasan.toStringAsFixed(1)),
          komentar: komentar,
          tag: tag,
          tanggal: _formatTanggal(hariLalu),
        ));
      }
    }
  }

  static String _formatTanggal(int hariLalu) {
    if (hariLalu <= 1) return 'Hari ini';
    if (hariLalu < 7) return '$hariLalu hari lalu';
    if (hariLalu < 30) return '${(hariLalu / 7).floor()} minggu lalu';
    return '${(hariLalu / 30).floor()} bulan lalu';
  }
}