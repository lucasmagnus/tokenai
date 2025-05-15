import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/asset/domain/repositories/asset_repository.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

part 'list_assets_event.dart';
part 'list_assets_state.dart';

class ListAssetsBloc extends Bloc<ListAssetsEvent, ListAssetsState> {
  final AssetRepository _assetRepository;

  ListAssetsBloc({
    required AssetRepository assetRepository,
  })  : _assetRepository = assetRepository,
        super(ListAssetsState.initial()) {
    on<LoadAssets>(_loadAssets);
  }

  Future<void> _loadAssets(LoadAssets event, Emitter emit) async {
    emit(state.copyWith(status: const Loading()));

    final response = await _assetRepository.listAssets();

    response.when(
      success: (data) => emit(state.copyWith(
        status: Success(data),
        assets: data,
      )),
      error: (code, message, exception) => emit(state.copyWith(
        status: Error(exception: exception),
      )),
    );
  }
} 