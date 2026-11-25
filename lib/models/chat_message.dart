
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  // Mengubah pesan menjadi Map untuk penyimpanan JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Membaca pesan dari JSON maupun data Firestore.
  static ChatMessage fromJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'];

    DateTime parsedTimestamp;

    if (rawTimestamp is DateTime) {
      parsedTimestamp = rawTimestamp;
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      try {
        // Mendukung Timestamp Firestore.
        parsedTimestamp = rawTimestamp.toDate() as DateTime;
      } catch (_) {
        parsedTimestamp = DateTime.now();
      }
    }

    return ChatMessage(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      isUser: json['isUser'] == true,
      timestamp: parsedTimestamp,
    );
  }
}