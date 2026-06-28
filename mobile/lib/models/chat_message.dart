class ChatMessage {
  final int? id;
  final int orderId;
  final String channel; // 'RIDER' or 'CALL_CENTER'
  final int senderId;
  final String senderRole; // 'CUSTOMER' | 'RIDER' | 'CALL_CENTER_AGENT'
  final String message;
  final DateTime? createdAt;

  ChatMessage({
    this.id,
    required this.orderId,
    required this.channel,
    required this.senderId,
    required this.senderRole,
    required this.message,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      orderId: json['orderId'],
      channel: json['channel'] ?? 'RIDER',
      senderId: json['senderId'],
      senderRole: json['senderRole'] ?? 'CUSTOMER',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toSendPayload() => {
        'senderId': senderId,
        'senderRole': senderRole,
        'message': message,
      };
}
