import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../helpers/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Cafe> _cafes = [];
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97316),
        title: const Text(
          'CafeDayu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // nanti diarahkan ke halaman login
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cafes.isEmpty
          ? const Center(
              child: Text('Belum ada data cafe.\nTambahkan lewat Admin.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _cafes.length,
              itemBuilder: (context, index) {
                final cafe = _cafes[index];
                return _buildCafeCard(cafe);
              },
            ),
    );
  }

  Widget _buildCafeCard(Cafe cafe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE5D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFFED7AA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Center(
              child: Icon(Icons.coffee, size: 36, color: Color(0xFFEA580C)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cafe.nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cafe.alamat,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFF97316)),
                    const SizedBox(width: 4),
                    Text(
                      cafe.rating.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
