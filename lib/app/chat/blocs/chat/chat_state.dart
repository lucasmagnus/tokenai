part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final RequestStatus status;
  final List<ChatMessage> messages;

  const ChatState({
    required this.status,
    required this.messages,
  });

  factory ChatState.initial() {
    return const ChatState(
      status: Idle(),
      messages: [],
    );
  }

  ChatState copyWith({
    RequestStatus? status,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [status, messages];
} 