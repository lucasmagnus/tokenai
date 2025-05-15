import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/core/screens/main/main_screen.dart';
import 'package:tokenai/services/snackbar.dart';
import 'package:tokenai/app/asset/screens/create_asset/create_asset_template.dart';

class CreateAssetScreen extends StatelessWidget {
  static const ROUTE_NAME = 'create-asset';

  final AssetBloc _assetBloc;

  const CreateAssetScreen(this._assetBloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _assetBloc,
      child: BlocListener<AssetBloc, AssetState>(
        listener: assetBlocListener,
        child: CreateAssetTemplate(
          onCreateAssetPressed: (code, flags) {
            _assetBloc.add(CreateAsset(code: code, flags: flags));
          },
        ),
      ),
    );
  }

  void assetBlocListener(context, state) {
    state.createStatus.when(
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
      success: (data) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainScreen.ROUTE_NAME,
              (route) => false,
        );
      }
    );
  }
}
