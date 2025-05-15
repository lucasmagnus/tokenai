import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/components/atoms/all.dart';
import 'package:tokenai/components/molecules/all.dart';
import 'package:tokenai/components/molecules/input/all.dart';
import 'package:tokenai/components/organisms/custom_form.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';

class CreateAssetTemplate extends StatefulWidget {
  final void Function(String, Map<String, bool>) onCreateAssetPressed;

  const CreateAssetTemplate({super.key, required this.onCreateAssetPressed});

  @override
  State<CreateAssetTemplate> createState() => _CreateAssetTemplateState();
}

class _CreateAssetTemplateState extends State<CreateAssetTemplate> {
  Map<String, bool> flags = {
    "authorizationRequired": false,
    "authorizationRevocable": false,
    "clawbackEnabled": false,
    "authorizationImmutable": false,
  };

  void _onFlagChanged(String key, bool value) {
    setState(() {
      flags[key] = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: CupertinoNavigationBar(
        middle: Text(
          'Create Asset',
          style: TextStyle(color: Theme.of(context).kTextColor),
        ),
        transitionBetweenRoutes: true,
        backgroundColor: Theme.of(context).kBackgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      body: SingleChildScrollView(
        child: CustomForm(
          builder: (GlobalKey<FormState> key) {
            String? code;
            return [
              TextInput(
                label: 'Asset Code',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator:
                    (String? value) =>
                        value == null || value.isEmpty ? "Empty" : null,
                onSaved: (String? value) => code = value,
              ),
              const SizedBox(height: 32),
              authorizationOptions(),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: BlocBuilder<AssetBloc, AssetState>(
                  builder: (context, state) {
                    return Button(
                      label: 'Create Asset',
                      type: ButtonType.PRIMARY,
                      loading: state.createStatus is Loading,
                      onPressed: () {
                        if (key.currentState?.validate() ?? false) {
                          key.currentState?.save();
                          widget.onCreateAssetPressed(code!, flags);
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ];
          },
        ),
      ),
    );
  }

  Widget authorizationOptions() {
    return Column(
      children: [
        CustomCheckbox(
          title: "Require Authorization",
          onChanged:
              (bool selected) =>
                  _onFlagChanged("authorizationRequired", selected),
          description:
              'Requires authorization to perform operations with the asset. Only authorized accounts can transact.',
        ),
        SizedBox(height: 16),
        CustomCheckbox(
          title: "Revocable Authorization",
          onChanged:
              (bool selected) =>
                  _onFlagChanged("authorizationRevocable", selected),
          description:
              'Allows the asset issuer to revoke authorization from an account at any time.',
        ),
        SizedBox(height: 16),
        CustomCheckbox(
          title: "Asset Recovery (Clawback)",
          onChanged:
              (bool selected) => _onFlagChanged("clawbackEnabled", selected),
          description:
              'Enables the asset issuer to recover assets from an account in case of fraud or error.',
        ),
        SizedBox(height: 16),
        CustomCheckbox(
          title: "Immutable Authorization",
          onChanged:
              (bool selected) =>
                  _onFlagChanged("authorizationImmutable", selected),
          description:
              'Authorization permissions cannot be changed after asset creation, ensuring consistent and predictable permissions.',
        ),
      ],
    );
  }
}
