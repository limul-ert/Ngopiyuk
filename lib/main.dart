
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

import 'providers/cart_provider.dart';
import 'providers/chat_provider.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';

import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase sebelum aplikasi dijalankan.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NgopiYukApp());
}

class NgopiYukApp extends StatelessWidget {
  const NgopiYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
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
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),

        // AuthGate menentukan halaman berdasarkan status Firebase.
        home: const AuthGate(),
      ),
    );
  }
}

// ============================================
// AUTH GATE
// Memeriksa status login Firebase.
// ============================================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Loading saat Firebase memeriksa sesi login.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A0A0A),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC8956D),
              ),
            ),
          );
        }

        // Debug status autentikasi Firebase.
        debugPrint('AUTH STATUS: ${snapshot.connectionState}');
        debugPrint('AUTH USER: ${snapshot.data?.email}');
        debugPrint('AUTH ERROR: ${snapshot.error}');

        // Jika pengguna sudah login, buka MainPage.
        if (snapshot.hasData) {
          return const MainPage();
        }

        // Jika pengguna belum login, buka LoginPage.
        return const LoginPage();
      },
    );
  }
}
