import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const NgopiYukApp());
}

class NgopiYukApp extends StatelessWidget {
  const NgopiYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NgopiYuk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8956D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),   // ← INI KUNCINYA
    );
  }
}