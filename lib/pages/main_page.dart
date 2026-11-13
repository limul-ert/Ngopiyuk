import 'package:flutter/material.dart';
import 'home_page.dart';
import 'order_history_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF181818);
  static const Color dividerColor = Color(0xFF252525);

  void _onTabTap(int index) {
    if (index == 0 && _currentIndex != 0) {
      _homeKey.currentState?.reloadUserData();
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // ❌ Tidak pakai bottomNavigationBar lagi
      // ✅ Navbar ditaruh sebagai overlay di Stack
      body: Stack(
        children: [
          // ===== CONTENT =====
          IndexedStack(
            index: _currentIndex,
            children: [
              HomePage(key: _homeKey),
              const OrderHistoryPage(),
              const ProfilePage(),
            ],
          ),

          // ===== FLOATING NAV (overlay) =====
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFloatingNav(),
          ),
        ],
      ),
    );
  }

  // ============================================
  // FLOATING NAV
  // ============================================
  Widget _buildFloatingNav() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(36), // ← full rounded (pill)
            border: Border.all(
              color: dividerColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                0,
                Icons.home_outlined,
                Icons.home,
                'Beranda',
              ),
              _buildNavItem(
                1,
                Icons.receipt_long_outlined,
                Icons.receipt_long,
                'Riwayat',
              ),
              _buildNavItem(
                2,
                Icons.person_outline,
                Icons.person,
                'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // NAV ITEM
  // ============================================
  Widget _buildNavItem(
      int index,
      IconData icon,
      IconData activeIcon,
      String label,
      ) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey('$index-$isActive'),
                color: isActive ? Colors.black : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.grey,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}