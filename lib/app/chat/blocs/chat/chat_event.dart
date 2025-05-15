part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ClearConversation extends ChatEvent {
  const ClearConversation();

  @override
  List<Object> get props => [];
}

class PaymentConfirmed extends ChatEvent {
  const PaymentConfirmed();

  @override
  List<Object> get props => [];
} 