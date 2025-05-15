import 'package:get_it/get_it.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/contacts/data/repositories/contact_repository_impl.dart';
import 'package:tokenai/app/contacts/domain/repositories/contact_repository.dart';
import 'package:tokenai/app/core/di/modules.dart';

void startContactModules() {
  _repositoryModules();
  _blocModules();
}

void _blocModules() {
  getIt.registerFactory<ContactBloc>(() => ContactBloc(getIt()));
}

void _repositoryModules() {
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(http: getIt()),
  );
}
