import 'package:tokenai/app/chat/domain/models/chat_message.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

abstract interface class ChatRepository {
  Future<RequestStatus> sendMessage({
    required String message,
    List<ChatMessage>? chatHistory,
  });
} 