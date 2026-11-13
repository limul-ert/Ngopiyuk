import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final int subtotal;
  final int serviceFee;
  final int total;
  final String namaPenerima;
  final String nomorHp;
  final String cafeName;
  final String metodeBayar;
  final String catatan;
  final DateTime tanggal;
  final String status;
  final DateTime? pickupTime; // ← ✅ null = "Segera"

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.namaPenerima,
    required this.nomorHp,
    required this.cafeName,
    required this.metodeBayar,
    required this.catatan,
    required this.tanggal,
    this.status = 'Menunggu Diambil',
    this.pickupTime,
  });

  // ============================================
  // FORMAT JAM PENGAMBILAN (buat display)
  // ============================================
  String get pickupTimeFormatted {
    if (pickupTime == null) return 'Segera';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pickupDate = DateTime(
      pickupTime!.year,
      pickupTime!.month,
      pickupTime!.day,
    );
    final diffDays = pickupDate.difference(today).inDays;

    final hourStr = pickupTime!.hour.toString().padLeft(2, '0');
    final minStr = pickupTime!.minute.toString().padLeft(2, '0');
    final timeStr = '$hourStr:$minStr';

    if (diffDays == 0) return 'Hari ini, $timeStr WIB';
    if (diffDays == 1) return 'Besok, $timeStr WIB';
    return '${pickupTime!.day}/${pickupTime!.month}/${pickupTime!.year}, $timeStr WIB';
  }

  bool get isImmediate => pickupTime == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'total': total,
      'namaPenerima': namaPenerima,
      'nomorHp': nomorHp,
      'cafeName': cafeName,
      'metodeBayar': metodeBayar,
      'catatan': catatan,
      'tanggal': tanggal.toIso8601String(),
      'status': status,
      'pickupTime': pickupTime?.toIso8601String(),
    };
  }

  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((i) => CartItem.fromJson(i))
          .toList(),
      subtotal: json['subtotal'],
      serviceFee: json['serviceFee'],
      total: json['total'],
      namaPenerima: json['namaPenerima'],
      nomorHp: json['nomorHp'],
      cafeName: json['cafeName'] ?? json['alamat'] ?? 'Cafe',
      metodeBayar: json['metodeBayar'],
      catatan: json['catatan'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
      status: json['status'] ?? 'Menunggu Diambil',
      pickupTime: json['pickupTime'] != null
          ? DateTime.parse(json['pickupTime'])
          : null,
    );
  }
}