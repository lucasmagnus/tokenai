import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/chat/blocs/chat/chat_bloc.dart';
import 'package:tokenai/app/chat/screens/chat/chat_template.dart';

class ChatScreen extends StatelessWidget {
  static const ROUTE_NAME = 'chat';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatTemplate(GetIt.I.get<ChatBloc>());
  }
} 