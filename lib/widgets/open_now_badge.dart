import 'package:material_ui/material_ui.dart';

/// Badge kecil "Buka" / "Tutup" yang dihitung dari teks jam buka cafe,
/// contoh: "08.00 - 24.00", "10.00 - 23.00" atau "24 Jam".
///
/// Memakai waktu WIB (UTC+7) supaya hasilnya sama walau jam HP/laptop
/// diatur ke zona waktu lain. Kalau format jam tidak dikenali, badge
/// tidak ditampilkan sama sekali.
class OpenNowBadge extends StatelessWidget {
  final String openHours;

  const OpenNowBadge({super.key, required this.openHours});

  /// true = buka, false = tutup, null = format jam tidak dikenali.
  static bool? isOpenNow(String openHours, {DateTime? now}) {
    if (openHours.toLowerCase().contains('24 jam')) return true;

    final matches =
        RegExp(r'(\d{1,2})[.:](\d{2})').allMatches(openHours).toList();
    if (matches.length < 2) return null;

    final open = int.parse(matches[0].group(1)!) * 60 +
        int.parse(matches[0].group(2)!);
    var close = int.parse(matches[1].group(1)!) * 60 +
        int.parse(matches[1].group(2)!);
    if (close == 0) close = 24 * 60; // "24.00" = tengah malam

    final wib = (now ?? DateTime.now())
        .toUtc()
        .add(const Duration(hours: 7));
    final current = wib.hour * 60 + wib.minute;

    if (close > open) return current >= open && current < close;
    return current >= open || current < close; // jam tutup lewat tengah malam
  }

  @override
  Widget build(BuildContext context) {
    final open = isOpenNow(openHours);
    if (open == null) return const SizedBox.shrink();

    final color = open ? const Color(0xFF5EE08A) : const Color(0xFFFF7A7A);
    final background =
        open ? const Color(0xFF1F3D2A) : const Color(0xFF3D1F1F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            open ? 'Buka' : 'Tutup',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}