import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/asset/blocs/list/list_assets_bloc.dart';
import 'package:tokenai/app/asset/data/repositories/asset_repository_impl.dart';
import 'package:tokenai/app/asset/domain/repositories/asset_repository.dart';
import 'package:tokenai/app/core/di/modules.dart';

void startAssetModules() {
  _repositoryModules();
  _blocModules();
}

void _blocModules() {
  getIt.registerFactory<AssetBloc>(() => AssetBloc(assetRepository: getIt()));
  getIt.registerFactory<ListAssetsBloc>(() => ListAssetsBloc(assetRepository: getIt()));
}

void _repositoryModules() {
  getIt.registerSingleton<AssetRepository>(AssetRepositoryImpl(http: getIt()));
}
