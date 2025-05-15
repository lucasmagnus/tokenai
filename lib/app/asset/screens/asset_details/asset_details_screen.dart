import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/asset/screens/asset_details/asset_details_template.dart';

class AssetDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = 'asset_details';

  final Asset asset;
  final AssetBloc assetBloc;

  const AssetDetailsScreen({
    super.key,
    required this.asset,
    required this.assetBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<AssetBloc>(),
      child: AssetDetailsTemplate(asset: asset, assetBloc: assetBloc),
    );
  }
} 