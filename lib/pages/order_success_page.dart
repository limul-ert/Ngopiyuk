import 'package:flutter/material.dart';
import '../models/order.dart';
import 'home_page.dart';

class OrderSuccessPage extends StatelessWidget {
  final Order order;

  const OrderSuccessPage({super.key, required this.order});

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color dividerColor = Color(0xFF252525);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== SUCCESS MARK =====
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: primaryColor,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ===== TITLE =====
              const Center(
                child: Text(
                  'Pesanan Dikonfirmasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Simpan Order ID untuk pengambilan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ===== TICKET CARD =====
              _buildTicketCard(),

              const SizedBox(height: 28),

              // ===== TOMBOL KEMBALI =====
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: dividerColor, width: 1),
      ),
      child: Column(
        children: [
          // ===== SECTION: AMBIL DI =====
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: primaryColor, width: 3),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(21, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AMBIL DI',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.cafeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tunjukkan Order ID ke kasir saat pengambilan',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _buildDashedDivider(),

          // ===== SECTION: DETAIL =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DETAIL PESANAN',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                _detailRow('Order ID', order.id),
                const SizedBox(height: 12),
                _detailRow('Nama', order.namaPenerima),

                // ===== JAM PENGAMBILAN =====
                const SizedBox(height: 12),
                _detailRow(
                  'Jam Ambil',
                  order.pickupTimeFormatted,
                  isPickup: true,
                ),

                const SizedBox(height: 12),
                _detailRow('Metode', order.metodeBayar),
                const SizedBox(height: 12),
                _detailRow('Status', order.status, isHighlight: true),

                if (order.catatan.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _detailRow('Catatan', order.catatan),
                ],

                const SizedBox(height: 20),
                Container(height: 1, color: dividerColor),
                const SizedBox(height: 16),

                _detailRow(
                  'Total',
                  'Rp ${order.total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return SizedBox(
      height: 1,
      child: Row(
        children: List.generate(
          40,
              (index) => Expanded(
            child: Container(
              height: 1,
              color: index % 2 == 0 ? dividerColor : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
      String label,
      String value, {
        bool isHighlight = false,
        bool isTotal = false,
        bool isPickup = false,
      }) {
    Color valueColor;
    if (isHighlight || isPickup) {
      valueColor = primaryColor;
    } else {
      valueColor = Colors.white;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: isTotal ? 13 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isPickup) ...[
                Icon(
                  order.isImmediate ? Icons.bolt : Icons.schedule,
                  color: primaryColor,
                  size: 14,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: isTotal ? 16 : 13,
                    fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: isTotal ? -0.3 : 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}