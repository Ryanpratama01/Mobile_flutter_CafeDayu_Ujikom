import '../models/cafe.dart';
import 'db_helper.dart';

class SeedData {
  static Future<void> insertInitialCafes() async {
    final db = DBHelper();
    final existing = await db.getAllCafes();

    // Supaya data tidak dobel kalau aplikasi dibuka berkali-kali
    if (existing.isNotEmpty) return;

    final List<Cafe> cafes = [
      Cafe(
        nama: 'Akara Coffee 2.0',
        alamat: 'Ruko Taman Dayu E-2/E-3, Pandaan',
        latitude: -7.6312,
        longitude: 112.6897,
        jamBuka: '08.00 - 22.00 WIB',
        kisaranHarga: 'Rp18.000 - Rp25.000',
        label: ['Estetik', 'Nongkrong', 'Nugasable'],
        rating: 4.8,
        deskripsi: 'Kafe industrial minimalis 3 lantai dengan rooftop garden bertema tanaman tropical. Signature dish Nasi Goreng Akara dan Chicken Cereal.',
      ),
      Cafe(
        nama: 'Bugs Cafe',
        alamat: 'Belakang Bug Street & Bloomfield, Taman Dayu',
        latitude: -7.6325,
        longitude: 112.6905,
        jamBuka: '09.00 - 23.00 WIB',
        kisaranHarga: 'Rp25.000 - Rp50.000',
        label: ['Estetik', 'Nongkrong'],
        rating: 4.6,
        deskripsi: 'Nuansa estetik dengan danau buatan di cekungan lembah. Fasilitas lengkap: outdoor area, parkir, spot foto, wedding venue, glamping.',
      ),
      Cafe(
        nama: "D'Gunungan Cafe",
        alamat: 'Area perbukitan Taman Dayu (lokasi tertinggi)',
        latitude: -7.6340,
        longitude: 112.6920,
        jamBuka: '11.00-22.00 (Weekdays), 10.00-22.00 (Weekend)',
        kisaranHarga: 'Rp23.000 - Rp27.000',
        label: ['Nugasable', 'Estetik'],
        rating: 4.5,
        deskripsi: 'Suasana sejuk di lokasi paling tinggi Taman Dayu dengan view pegunungan dan lapangan golf hijau. Menu Nusantara dan Western.',
      ),
      Cafe(
        nama: 'The Olive Branch',
        alamat: 'Klaster Halimun Fajar, Taman Dayu, Pandaan',
        latitude: -7.6318,
        longitude: 112.6910,
        jamBuka: 'Senin-Jumat 10.00-21.00, Sabtu-Minggu 08.00-21.00',
        kisaranHarga: 'Rp15.000 - Rp35.000',
        label: ['Estetik', 'Nongkrong'],
        rating: 4.7,
        deskripsi: 'Berkonsep rustic ala pedesaan Eropa klasik, dikelilingi hamparan bukit hijau yang sangat cocok untuk spot foto.',
      ),
      Cafe(
        nama: 'Cesa Little Garden (CLG)',
        alamat: 'Kavling Palazio, Jl. Raya Surabaya-Malang Km. 48',
        latitude: -7.6305,
        longitude: 112.6885,
        jamBuka: 'Senin-Kamis 10.00-22.00, Jumat-Minggu 10.00-23.00',
        kisaranHarga: 'Rp15.000 - Rp50.000',
        label: ['Estetik', 'Nongkrong'],
        rating: 4.6,
        deskripsi: 'Konsep industrial dipadukan ornamen kaca dengan hiasan tanaman hijau dan bunga. Menu Indonesia, Korea, Jepang, hingga Western.',
      ),
      Cafe(
        nama: 'Calli Mera',
        alamat: 'Klaster Halimun Fajar, Taman Dayu, Pandaan',
        latitude: -7.6320,
        longitude: 112.6912,
        jamBuka: 'Senin-Jumat 10.00-21.00, Sabtu-Minggu 07.00-21.00',
        kisaranHarga: 'Rp25.000 - Rp400.000',
        label: ['Estetik', 'Nongkrong'],
        rating: 4.7,
        deskripsi: 'Bangunan khas ala Santorini berwarna putih dan biru. Menu favorit fish and chips, herbal tisane, grill panini sandwich.',
      ),
      Cafe(
        nama: 'Kamandaru Villas Cafe',
        alamat: 'Area depan Kamandaru Villas, Taman Dayu',
        latitude: -7.6300,
        longitude: 112.6880,
        jamBuka: '09.00 - 21.00 WIB',
        kisaranHarga: 'Rp20.000 - Rp45.000',
        label: ['Nongkrong', 'Estetik'],
        rating: 4.5,
        deskripsi: 'Cafe semi outdoor yang cantik dengan bunga-bunga menghiasi area, seating empuk dan nyaman untuk nongkrong santai.',
      ),
      Cafe(
        nama: 'Bata Merah Koffie (Batamera)',
        alamat: 'The Taman Dayu, Sukorejo, Karang Jati, Pandaan',
        latitude: -7.6295,
        longitude: 112.6875,
        jamBuka: '09.00 - 22.00 WIB',
        kisaranHarga: 'Rp10.000 - Rp30.000',
        label: ['Estetik', 'Nugasable', 'Worth It'],
        rating: 4.6,
        deskripsi: 'Suasana klasik vintage dengan dinding bata ekspos. Dikenal dengan minuman khas cascara, cocok untuk kerja maupun nongkrong tenang.',
      ),
      Cafe(
        nama: 'Kopi Telu Sawah View',
        alamat: 'Gerbang masuk perumahan Taman Dayu (belok kiri 100m)',
        latitude: -7.6330,
        longitude: 112.6895,
        jamBuka: '09.00 - 21.00 WIB',
        kisaranHarga: 'Rp15.000 - Rp40.000',
        label: ['Estetik', 'Nongkrong'],
        rating: 4.7,
        deskripsi: 'Outdoor area seluas 1 hektar dengan suasana sawah dan pegunungan hijau. Kids friendly dengan playground untuk anak.',
      ),
      Cafe(
        nama: 'Leezin Kopitiam',
        alamat: 'Kawasan Taman Dayu, Pandaan',
        latitude: -7.6310,
        longitude: 112.6900,
        jamBuka: '08.00 - 21.00 WIB',
        kisaranHarga: 'Rp12.000 - Rp30.000',
        label: ['Nongkrong', 'Worth It'],
        rating: 4.4,
        deskripsi: 'Kopitiam dengan suasana santai khas Asia Tenggara, cocok untuk nongkrong dan ngobrol santai.',
      ),
      Cafe(
        nama: 'Pesen Kopi Plus',
        alamat: 'Kawasan Taman Dayu, Pandaan',
        latitude: -7.6315,
        longitude: 112.6892,
        jamBuka: '08.00 - 22.00 WIB',
        kisaranHarga: 'Rp15.000 - Rp35.000',
        label: ['Nongkrong', 'Nugasable'],
        rating: 4.5,
        deskripsi: 'Cabang terbesar Pesen Kopi di kawasan ini, tempat cozy dan luas, baru opening dengan fasilitas lengkap.',
      ),
    ];

    for (final cafe in cafes) {
      await db.insertCafe(cafe);
    }
  }
}