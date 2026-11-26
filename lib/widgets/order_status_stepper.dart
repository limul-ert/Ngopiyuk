import 'package:material_ui/material_ui.dart';

/// Stepper progres pesanan: Dipesan -> Diproses -> Selesai.
///
/// Membaca teks `order.status` yang sudah ada:
///  - "Menunggu Diambil"      -> langkah 1 (Dipesan)
///  - "Diproses"              -> langkah 2
///  - "Selesai" / "Diambil"   -> langkah 3
///  - "Dibatalkan"            -> tampil pesan dibatalkan
///
/// Progres akan bergerak kalau field `status` pesanan di Firestore diubah.
class OrderStatusStepper extends StatelessWidget {
  final String status;

  const OrderStatusStepper({super.key, required this.status});

  static const Color _primary = Color(0xFFC8956D);
  static const Color _inactive = Color(0xFF333333);
  static const List<String> _labels = ['Dipesan', 'Diproses', 'Selesai'];

  int get _step {
    switch (status.toLowerCase().trim()) {
      case 'diproses':
        return 1;
      case 'selesai':
      case 'diambil':
        return 2;
      default:
        return 0;
    }
  }

  bool get _cancelled => status.toLowerCase().trim() == 'dibatalkan';

  @override
  Widget build(BuildContext context) {
    if (_cancelled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF3D1F1F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel, color: Color(0xFFFF7A7A), size: 18),
            SizedBox(width: 8),
            Text(
              'Pesanan dibatalkan',
              style: TextStyle(
                color: Color(0xFFFF7A7A),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final step = _step;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_labels.length, (i) {
        final done = i < step;
        final current = i == step;
        final reached = i <= step;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      color: i == 0
                          ? Colors.transparent
                          : (reached ? _primary : _inactive),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: reached ? _primary : _inactive,
                      shape: BoxShape.circle,
                      border: current
                          ? Border.all(
                              color: _primary.withValues(alpha: 0.35),
                              width: 4,
                            )
                          : null,
                    ),
                    child: done
                        ? const Icon(Icons.check, size: 13, color: Colors.black)
                        : null,
                  ),
                  Expanded(
                    child: Container(
                      height: 3,
                      color: i == _labels.length - 1
                          ? Colors.transparent
                          : (i < step ? _primary : _inactive),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _labels[i],
                style: TextStyle(
                  color: reached ? Colors.white : Colors.grey,
                  fontSize: 11,
                  fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}