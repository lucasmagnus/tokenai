import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/chat/domain/models/chat_message.dart';
import 'package:tokenai/app/chat/domain/repositories/chat_repository.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatState.initial()) {
    on<SendMessage>(_sendMessage);
    on<ClearConversation>(_clearConversation);
    on<PaymentConfirmed>(_handlePaymentConfirmed);
  }

  Future<void> _sendMessage(SendMessage event, Emitter emit) async {
    // Add user message to state
    final userMessage = ChatMessage(
      text: event.message,
      time: DateTime.now().toString().split(' ')[1].substring(0, 5),
      isMe: true,
    );

    emit(state.copyWith(messages: [...state.messages, userMessage]));

    // Send to backend
    emit(state.copyWith(status: const Loading()));

    final response = await _chatRepository.sendMessage(
      message: event.message,
      chatHistory: state.messages,
    );

    response.when(
      success: (data) {
        final aiMessage = ChatMessage(
          text: data['data']?['message'] ?? '👍',
          time: DateTime.now().toString().split(' ')[1].substring(0, 5),
          isMe: false,
          action: data['data']?['data']?['action']?['action'],
          xdr: data['data']?['data']?['xdr'],
        );

        emit(
          state.copyWith(
            status: response,
            messages: [...state.messages, aiMessage],
          ),
        );
      },
      error: (code, message, exception) {
        emit(state.copyWith(status: response));
      },
    );
  }

  void _clearConversation(ClearConversation event, Emitter emit) {
    emit(ChatState.initial());
  }

  void _handlePaymentConfirmed(PaymentConfirmed event, Emitter<ChatState> emit) {
    final confirmationMessage = ChatMessage(
      text: 'Payment confirmed 👍',
      time: DateTime.now().toString().split(' ')[1].substring(0, 5),
      isMe: false,
    );

    emit(state.copyWith(messages: [...state.messages, confirmationMessage]));
  }
}
