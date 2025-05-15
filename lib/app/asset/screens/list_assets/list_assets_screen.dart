import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/services/snackbar.dart';

import 'list_assets_template.dart';

class ListAssetsScreen extends StatelessWidget {
  static const ROUTE_NAME = 'list-assets';

  final AssetBloc _assetBloc;

  const ListAssetsScreen(this._assetBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _assetBloc..add(const ListAssets()),
      child: BlocListener<AssetBloc, AssetState>(
        listener: assetBlocListener,
        child: BlocBuilder<AssetBloc, AssetState>(
          builder: (context, state) {
            return ListAssetsTemplate(
              assets: state.assets,
              listStatus: state.listStatus,
              onRefresh: () => _assetBloc.add(const ListAssets()),
            );
          },
        ),
      ),
    );
  }

  void assetBlocListener(context, state) {
    state.listStatus.when(
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );
  }
} 