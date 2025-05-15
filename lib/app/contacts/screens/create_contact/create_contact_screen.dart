import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/contacts/domain/repositories/contact_repository.dart';
import 'package:tokenai/components/atoms/all.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';

class CreateContactScreen extends StatefulWidget {
  static const ROUTE_NAME = 'create-contact';

  final ContactBloc _contactBloc;

  const CreateContactScreen(this._contactBloc, {super.key});

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _walletController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget._contactBloc,
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          return BaseLayout(
            appBar: CupertinoNavigationBar(
              middle: Text(
                'Add Contact',
                style: TextStyle(color: Theme.of(context).kTextColor),
              ),
              transitionBetweenRoutes: true,
              backgroundColor: Theme.of(context).kBackgroundColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Theme.of(context).kTextColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _walletController,
                      decoration: InputDecoration(
                        labelText: 'Wallet Address',
                        labelStyle: TextStyle(
                          color: Theme.of(context).kTextColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a wallet address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Button(
                      label: "Add Contact",
                      onPressed: () {
                        state is ContactLoading
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ContactBloc>().add(
                                  AddContact(
                                    name: _nameController.text,
                                    wallet: _walletController.text,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            };
                      },
                      type: ButtonType.PRIMARY,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
