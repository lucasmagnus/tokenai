import 'package:tokenai/app/chat/domain/models/chat_message.dart';
import 'package:tokenai/app/chat/domain/repositories/chat_repository.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/constants/endpoints.dart';
import 'package:tokenai/interfaces/http.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Http _http;

  ChatRepositoryImpl({required Http http}) : _http = http;

  @override
  Future<RequestStatus> sendMessage({
    required String message,
    List<ChatMessage>? chatHistory,
  }) async {
    try {
      final publicKey = await SecureStorageServiceImpl().getPublicKey();
      final response = await _http.post(
        url: Endpoints.chat,
        data: {
          'message': message,
          'chatHistory': chatHistory?.map((msg) => msg.toJson()).toList(),
          'wallet': publicKey
        },
      );

      return Success(response);
    } on Exception catch (error) {
      return Error(exception: error);
    }
  }
} 