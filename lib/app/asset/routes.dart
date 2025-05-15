import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/asset/screens/asset_details/asset_details_screen.dart';
import 'package:tokenai/app/asset/screens/create_asset/create_asset_screen.dart';
import 'package:tokenai/app/asset/screens/list_assets/list_assets_screen.dart';

import 'domain/models/asset.dart';

final Map<String, Widget Function(BuildContext)> assetRoutes = {
  CreateAssetScreen.ROUTE_NAME:
      (context) => CreateAssetScreen(GetIt.I.get<AssetBloc>()),
  ListAssetsScreen.ROUTE_NAME:
      (context) => ListAssetsScreen(GetIt.I.get<AssetBloc>()),
  AssetDetailsScreen.ROUTE_NAME: (context) {
    final asset = ModalRoute.of(context)!.settings.arguments as Asset;
    return AssetDetailsScreen(
      asset: asset,
      assetBloc: GetIt.I.get<AssetBloc>(),
    );
  },
};
