class ChatMessage {
  final String text;
  final String time;
  final bool isMe;
  final String? action;
  String? xdr;
  bool? loading;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isMe,
    this.xdr,
    this.action,
    this.loading
  });

  Map<String, dynamic> toJson() {
    return {
      'content': text,
      'role': isMe ? 'user' : 'assistant',
      'xdr': xdr,
      'action': action
    };
  }
} 