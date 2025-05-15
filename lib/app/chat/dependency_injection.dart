import 'package:tokenai/app/chat/blocs/chat/chat_bloc.dart';
import 'package:tokenai/app/chat/data/repositories/chat_repository_impl.dart';
import 'package:tokenai/app/chat/domain/repositories/chat_repository.dart';
import 'package:tokenai/app/core/di/modules.dart';

void startChatModules() {
  _repositoryModules();
  _blocModules();
}

void _blocModules() {
  getIt.registerFactory<ChatBloc>(() => ChatBloc(chatRepository: getIt()));
}

void _repositoryModules() {
  getIt.registerSingleton<ChatRepository>(ChatRepositoryImpl(http: getIt()));
} 