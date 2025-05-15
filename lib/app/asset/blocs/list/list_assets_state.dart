part of 'list_assets_bloc.dart';

class ListAssetsState extends Equatable {
  final RequestStatus status;
  final List<Asset> assets;

  const ListAssetsState({
    required this.status,
    required this.assets,
  });

  factory ListAssetsState.initial() {
    return const ListAssetsState(
      status: Loading(),
      assets: [],
    );
  }

  ListAssetsState copyWith({
    RequestStatus? status,
    List<Asset>? assets,
  }) {
    return ListAssetsState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
    );
  }

  @override
  List<Object> get props => [status, assets];
} 