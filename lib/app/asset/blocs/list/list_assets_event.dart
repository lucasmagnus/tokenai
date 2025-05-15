part of 'list_assets_bloc.dart';

abstract class ListAssetsEvent extends Equatable {
  const ListAssetsEvent();

  @override
  List<Object> get props => [];
}

class LoadAssets extends ListAssetsEvent {} 