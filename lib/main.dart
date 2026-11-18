import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- IMPORT GOOGLE FONTS

// Pastikan path import di bawah ini sesuai dengan struktur folder Anda
import 'providers/cart_provider.dart';
import 'providers/chat_provider.dart';
import 'pages/login_page.dart';

void main() {
  // Menjalankan aplikasi
  runApp(const NgopiYukApp());
}

class NgopiYukApp extends StatelessWidget {
  const NgopiYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // Memanggil loadCart() saat CartProvider pertama kali dibuat
          create: (_) => CartProvider()..loadCart(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'NgopiYuk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC8956D),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          
          // ===== IMPLEMENTASI PACKAGE GEMS: GOOGLE FONTS =====
          // Menggunakan font Poppins untuk seluruh teks di aplikasi
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        home: const LoginPage(),
      ),
    );
  }
}