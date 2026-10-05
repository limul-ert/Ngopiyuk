import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final int subtotal;
  final int serviceFee;
  final int total;
  final String namaPenerima;
  final String nomorHp;
  final String alamat;
  final String metodeBayar;
  final String catatan;
  final DateTime tanggal;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.namaPenerima,
    required this.nomorHp,
    required this.alamat,
    required this.metodeBayar,
    required this.catatan,
    required this.tanggal,
    this.status = 'Diproses',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'total': total,
      'namaPenerima': namaPenerima,
      'nomorHp': nomorHp,
      'alamat': alamat,
      'metodeBayar': metodeBayar,
      'catatan': catatan,
      'tanggal': tanggal.toIso8601String(),
      'status': status,
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
      alamat: json['alamat'],
      metodeBayar: json['metodeBayar'],
      catatan: json['catatan'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
      status: json['status'] ?? 'Diproses',
    );
  }
}