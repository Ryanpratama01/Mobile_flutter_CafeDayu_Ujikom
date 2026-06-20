import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cafe.dart';
import '../models/ulasan.dart';
import '../helpers/db_helper.dart';

class DetailCafeScreen extends StatefulWidget {
  final Cafe cafe;
  const DetailCafeScreen({super.key, required this.cafe});

  @override
  State<DetailCafeScreen> createState() => _DetailCafeScreenState();
}

class _DetailCafeScreenState extends State<DetailCafeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Ulasan> _ulasanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUlasan();
  }

  Future<void> _loadUlasan() async {
    final list = await _dbHelper.getUlasanByCafe(widget.cafe.id!);
    setState(() {
      _ulasanList = list;
      _isLoading = false;
    });
  }

  Future<void> _openMaps({bool satellite = false}) async {
    final cafe = widget.cafe;

    // coba buka langsung pakai geo: intent dulu (paling kompatibel di Android)
    final geoUrl = Uri.parse('geo:${cafe.latitude},${cafe.longitude}?q=${cafe.latitude},${cafe.longitude}(${Uri.encodeComponent(cafe.nama)})');

    // fallback ke Google Maps via browser/app, dengan parameter satelit kalau diminta
    final webUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${cafe.latitude},${cafe.longitude}'
      '${satellite ? '&basemap=satellite' : ''}',
    );

    try {
      final launched = await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      try {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } catch (e2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak bisa membuka aplikasi Maps')),
          );
        }
      }
    }
  }

  void _showMapsOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Text(
              'Buka Navigasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.cafe.nama,
              style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
            ),
            const SizedBox(height: 18),
            _mapsOptionTile(
              icon: Icons.map_rounded,
              label: 'Peta Standar',
              subtitle: 'Tampilan jalan & lokasi biasa',
              onTap: () {
                Navigator.pop(context);
                _openMaps(satellite: false);
              },
            ),
            const SizedBox(height: 10),
            _mapsOptionTile(
              icon: Icons.satellite_alt_rounded,
              label: 'Peta Satelit',
              subtitle: 'Tampilan foto udara/satelit',
              onTap: () {
                Navigator.pop(context);
                _openMaps(satellite: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapsOptionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFDBA74)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFEA580C)]),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFF97316)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cafe = widget.cafe;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            backgroundColor: const Color(0xFFF97316),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFB923C), Color(0xFFC2410C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.coffee_rounded, size: 64, color: Colors.white70),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border_rounded, size: 19),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(cafe.nama, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '● Buka',
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF16A34A), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(cafe.alamat, style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(cafe.rating.toString(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < cafe.rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 15,
                                color: const Color(0xFFF97316),
                              );
                            }),
                          ),
                          Text('Dari ${_ulasanList.length} ulasan', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(spacing: 6, runSpacing: 6, children: cafe.label.map((l) => _miniLabel(l)).toList()),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _infoBox(Icons.access_time_rounded, cafe.jamBuka, 'Jam buka')),
                      const SizedBox(width: 10),
                      Expanded(child: _infoBox(Icons.payments_rounded, cafe.kisaranHarga, 'Kisaran harga')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Preview lokasi (peta statis sederhana)
                  GestureDetector(
                    onTap: _showMapsOptions,
                    child: Container(
                      width: double.infinity,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.map_rounded, size: 60, color: Colors.grey[400]),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF97316),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                              ),
                              child: const Text(
                                'Ketuk untuk buka peta',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _showMapsOptions,
                      icon: const Icon(Icons.navigation_rounded, size: 19),
                      label: const Text('Navigasi ke Lokasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0xFFF97316).withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text('Tentang Cafe', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(cafe.deskripsi, style: TextStyle(fontSize: 12.5, color: Colors.grey[700], height: 1.5)),
                  const SizedBox(height: 24),

                  Text('Ulasan Pengguna (${_ulasanList.length})', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: Color(0xFFF97316)))
                  else if (_ulasanList.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.center,
                      child: Text(
                        'Belum ada ulasan untuk cafe ini.\nJadilah yang pertama memberi ulasan!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey[500]),
                      ),
                    )
                  else
                    ..._ulasanList.map((u) => _reviewCard(u)),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDBA74)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFFEA580C), fontWeight: FontWeight.w600)),
    );
  }

  Widget _infoBox(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE5D0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFF97316), size: 18),
          const SizedBox(height: 5),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 1),
          Text(label, style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _reviewCard(Ulasan u) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFFFE5D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFFFED7AA),
                    child: Text(
                      u.namaUser.isNotEmpty ? u.namaUser[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFEA580C)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.namaUser, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                      Text(u.tanggal, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < u.rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 12,
                    color: const Color(0xFFF97316),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(u.komentar, style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('#${u.tag}', style: const TextStyle(fontSize: 9.5, color: Color(0xFFEA580C), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}