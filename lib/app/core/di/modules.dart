import 'package:get_it/get_it.dart';
import 'package:tokenai/app/asset/dependency_injection.dart';
import 'package:tokenai/app/auth/dependency_injection.dart';
import 'package:tokenai/app/chat/dependency_injection.dart';
import 'package:tokenai/app/contacts/dependency_injection.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/app/core/domain/services/secure_storage_service.dart';
import 'package:tokenai/constants/env.dart';
import 'package:tokenai/interfaces/http.dart';

GetIt getIt = GetIt.instance;

void startGetItModules() {
  _localModules();
  _repositoryModules();
  _networkModules();
  startAuthModules();
  startAssetModules();
  startChatModules();
  startContactModules();
}

void _networkModules() {
  getIt.registerSingleton<Http>(Http("http://localhost:8000/api/v1/"));
}

void _localModules() {
  getIt.registerSingleton<SecureStorageService>(SecureStorageServiceImpl());
}

void _repositoryModules() {}
