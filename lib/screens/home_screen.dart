import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../helpers/db_helper.dart';
import 'login_screen.dart';

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
    _loadCafes();
  }

  Future<void> _loadCafes() async {
    final cafes = await _dbHelper.getAllCafes();
    setState(() {
      _cafes = cafes;
      _isLoading = false;
    });
  }

  List<Cafe> get _filteredCafes {
    var result = _cafes;
    if (_selectedFilter != 'Semua') {
      result = result.where((c) => c.label.contains(_selectedFilter)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((c) => c.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  List<Cafe> get _displayedCafes => _filteredCafes.take(3).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
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
                child: Text(
                  'Cafe tidak ditemukan',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _displayedCafes.length) {
                      return _buildLockSection();
                    }
                    return _buildCafeCard(_displayedCafes[index], index);
                  },
                  childCount: _displayedCafes.length + 1,
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
      padding: const EdgeInsets.fromLTRB(18, 50, 18, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
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
                        Icon(Icons.coffee, color: Colors.white, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'CafeDayu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Rekomendasi cafe Taman Dayu',
                      style: TextStyle(color: Color(0xFFFFE5D0), fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 19),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFFF97316), size: 19),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
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
    ];
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF1E5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: SizedBox(
        height: 16,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: reviews.length,
          itemBuilder: (context, i) {
            final r = reviews[i];
            return Padding(
              padding: const EdgeInsets.only(right: 22),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF97316), size: 13),
                  const SizedBox(width: 4),
                  Text(
                    '${r['name']} di ${r['cafe']}: "${r['text']}"',
                    style: const TextStyle(fontSize: 11, color: Color(0xFFC2410C)),
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
      color: const Color(0xFFFFF8F3),
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
                  color: isActive ? const Color(0xFFF97316) : Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: isActive ? const Color(0xFFF97316) : const Color(0xFFFDBA74),
                    width: isActive ? 1.5 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF97316).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: isActive ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        filter['icon'],
                        size: 13,
                        color: isActive ? Colors.white : const Color(0xFFEA580C),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      filter['label'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
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

  Widget _buildCafeCard(Cafe cafe, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFE5D0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFED7AA), Color(0xFFFDBA74)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Center(
                child: Icon(Icons.coffee_rounded, size: 34, color: Color(0xFFEA580C)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.nama,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cafe.alamat,
                    style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: cafe.label.map((l) => _miniLabel(l)).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF97316)),
                      const SizedBox(width: 3),
                      Text(
                        cafe.rating.toString(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cafe.jamBuka,
                          style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
  }

  Widget _miniLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFDBA74)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 9.5, color: Color(0xFFEA580C), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLockSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDBA74)),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7ED),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: Color(0xFFF97316), size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Masuk untuk lihat semua cafe,\nulasan lengkap & rute lokasi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Masuk / Daftar Gratis',
                style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}