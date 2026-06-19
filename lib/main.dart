import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'helpers/seed_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SeedData.insertInitialCafes(); // isi data awal kalau database masih kosong
  runApp(const CafeDayuApp());
}

class CafeDayuApp extends StatelessWidget {
  const CafeDayuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CafeDayu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF97316),
        scaffoldBackgroundColor: const Color(0xFFFFF8F3),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}