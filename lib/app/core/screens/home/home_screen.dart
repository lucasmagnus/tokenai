import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/services/snackbar.dart';

import 'home_template.dart';

class HomeScreen extends StatelessWidget {
  static const ROUTE_NAME = 'home';

  final AssetBloc _assetBloc;

  const HomeScreen(this._assetBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _assetBloc
        ..add(const ListAssets())
        ..add(const ListTransactions()),
      child: BlocListener<AssetBloc, AssetState>(
        listener: _assetBlocListener,
        child: BlocBuilder<AssetBloc, AssetState>(
          builder: (context, state) {
            return HomeTemplate(
              assets: state.assets,
              transactions: state.transactions,
              listStatus: state.listStatus,
              transactionsStatus: state.transactionsStatus,
              onRefresh: () {
                context.read<AssetBloc>().add(const ListAssets());
                context.read<AssetBloc>().add(const ListTransactions());
              },
            );
          },
        ),
      ),
    );
  }

  void _assetBlocListener(BuildContext context, AssetState state) {
    state.listStatus.when(
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );

    state.transactionsStatus.when(
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );
  }
}
