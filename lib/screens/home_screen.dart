import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../helpers/db_helper.dart';
import '../helpers/session_helper.dart';
import 'login_screen.dart';
import 'detail_cafe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Cafe> _cafes = [];
  bool _isLoading = true;
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  bool _isLoggedIn = false;
  String? _userName;

  final ScrollController _marqueeController = ScrollController();
  Timer? _marqueeTimer;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Semua', 'icon': Icons.apps_rounded},
    {'label': 'Nugasable', 'icon': Icons.menu_book_rounded},
    {'label': 'Nongkrong', 'icon': Icons.groups_rounded},
    {'label': 'Estetik', 'icon': Icons.camera_alt_rounded},
    {'label': 'Worth It', 'icon': Icons.payments_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _checkSession();
    _loadCafes();
  }

  @override
  void dispose() {
    _marqueeTimer?.cancel();
    _marqueeController.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    final loggedIn = await SessionHelper.isLoggedIn();
    final name = await SessionHelper.getUserName();
    setState(() {
      _isLoggedIn = loggedIn;
      _userName = name;
    });
  }

  Future<void> _loadCafes() async {
    final cafes = await _dbHelper.getAllCafes();
    setState(() {
      _cafes = cafes;
      _isLoading = false;
    });
    if (cafes.isNotEmpty) _startMarquee();
  }

  void _startMarquee() {
    _marqueeTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_marqueeController.hasClients) return;
      final max = _marqueeController.position.maxScrollExtent;
      var next = _marqueeController.offset + 0.6;
      if (next >= max) next = 0;
      _marqueeController.jumpTo(next);
    });
  }

  List<Cafe> get _filteredCafes {
    var result = _cafes;
    if (_selectedFilter != 'Semua') {
      result = result.where((c) => c.label.contains(_selectedFilter)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result.where((c) => c.nama.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return result;
  }

  List<Cafe> get _displayedCafes =>
      _isLoggedIn ? _filteredCafes : _filteredCafes.take(3).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildMarquee()),
          SliverToBoxAdapter(child: _buildFilters()),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFF97316))),
            )
          else if (_filteredCafes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('Cafe tidak ditemukan', style: TextStyle(color: Colors.grey[500])),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (!_isLoggedIn && index == _displayedCafes.length) {
                      return _buildLockSection();
                    }
                    final isLastCard = !_isLoggedIn && index == _displayedCafes.length - 1;
                    return _buildCafeCard(
                      _displayedCafes[index],
                      index,
                      blurred: isLastCard,
                    );
                  },
                  childCount: _isLoggedIn ? _displayedCafes.length : _displayedCafes.length + 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 50, 18, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFB923C), Color(0xFFF97316), Color(0xFFC2410C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.coffee_rounded, color: Colors.white, size: 21),
                        SizedBox(width: 7),
                        Text(
                          'CafeDayu',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _isLoggedIn && _userName != null
                          ? 'Halo, $_userName!'
                          : 'Rekomendasi cafe Taman Dayu',
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!_isLoggedIn) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Icon(
                    _isLoggedIn ? Icons.person : Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Color(0xFFF97316), size: 20),
                const SizedBox(width: 9),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      hintText: 'Cari nama cafe...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarquee() {
    if (_cafes.isEmpty) return const SizedBox.shrink();
    final reviews = [
      {'name': 'Rizal', 'cafe': _cafes[0].nama, 'text': 'tempatnya nyaman buat nugas!'},
      {'name': 'Fina', 'cafe': _cafes.length > 1 ? _cafes[1].nama : _cafes[0].nama, 'text': 'view-nya estetik banget'},
      {'name': 'Damar', 'cafe': _cafes.length > 2 ? _cafes[2].nama : _cafes[0].nama, 'text': 'worth it harganya'},
      {'name': 'Ayu', 'cafe': _cafes.length > 3 ? _cafes[3].nama : _cafes[0].nama, 'text': 'wifi-nya kencang banget'},
    ];
    final loopReviews = [...reviews, ...reviews];

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF1E5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 16,
        child: ListView.builder(
          controller: _marqueeController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loopReviews.length,
          itemBuilder: (context, i) {
            final r = loopReviews[i];
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF97316), size: 13),
                  const SizedBox(width: 4),
                  Text(
                    '${r['name']} di ${r['cafe']}: "${r['text']}"',
                    style: const TextStyle(fontSize: 11, color: Color(0xFFC2410C), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: const Color(0xFFFAF7F4),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isActive = _selectedFilter == filter['label'];
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter['label']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFEA580C)])
                      : null,
                  color: isActive ? null : Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFFDBA74)),
                  boxShadow: isActive
                      ? [BoxShadow(color: const Color(0xFFF97316).withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: isActive ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(filter['icon'], size: 13, color: isActive ? Colors.white : const Color(0xFFEA580C)),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      filter['label'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : const Color(0xFFEA580C),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCafeCard(Cafe cafe, int index, {bool blurred = false}) {
    final card = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailCafeScreen(cafe: cafe)),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFE5D0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 92,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFED7AA), Color(0xFFFB923C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(child: Icon(Icons.coffee_rounded, size: 36, color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cafe.nama, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(cafe.alamat, style: const TextStyle(fontSize: 11.5, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 9),
                  Wrap(spacing: 5, runSpacing: 5, children: cafe.label.map((l) => _miniLabel(l)).toList()),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF97316)),
                      const SizedBox(width: 3),
                      Text(cafe.rating.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(cafe.jamBuka, style: const TextStyle(fontSize: 10.5, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget wrapped = card;

    if (blurred) {
      wrapped = Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 3.2, sigmaY: 3.2),
              child: card,
            ),
          ),
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
        ],
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: wrapped,
    );
  }

  Widget _miniLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFFDBA74)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 9.5, color: Color(0xFFEA580C), fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildLockSection() {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFEA580C)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            const Text(
              'Masih banyak cafe seru lainnya!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Masuk untuk lihat semua cafe, ulasan lengkap & rute lokasi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  elevation: 3,
                  shadowColor: const Color(0xFFF97316).withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Masuk / Daftar Gratis', style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}