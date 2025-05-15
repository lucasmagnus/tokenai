import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/components/atoms/all.dart';
import 'package:tokenai/components/molecules/input/all.dart';

class AssetActionBottomSheet extends StatefulWidget {
  final String title;
  final String action;
  final AssetBloc bloc;
  final String assetCode;

  const AssetActionBottomSheet({
    super.key,
    required this.title,
    required this.action,
    required this.bloc,
    required this.assetCode,
  });

  @override
  State<AssetActionBottomSheet> createState() => _AssetActionBottomSheetState();
}

class _AssetActionBottomSheetState extends State<AssetActionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
  bool _isClosing = false;

  void _handleConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (widget.action == 'Mint') {
        widget.bloc.add(MintAsset(
          code: widget.assetCode,
          amount: _amount!,
        ));
      } else {
        widget.bloc.add(BurnAsset(
          code: widget.assetCode,
          amount: _amount!,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBloc, AssetState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final status = widget.action == 'Mint' ? state.mintStatus : state.burnStatus;

        if (status is Success && !_isClosing) {
          _isClosing = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: TextInput(
                    label: 'Amount',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _amount = double.tryParse(value ?? '');
                    },
                  ),
                ),
                const SizedBox(height: 16),
                status is Loading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Button(
                        label: widget.action,
                        type: ButtonType.PRIMARY,
                        onPressed: _handleConfirm,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
