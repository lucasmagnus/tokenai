import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/contacts/domain/models/contact.dart';
import 'package:tokenai/app/contacts/screens/create_contact/create_contact_screen.dart';
import 'package:tokenai/app/contacts/screens/contact_details/contact_details_screen.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/utils/stellar_utils.dart';

class ContactsScreen extends StatelessWidget {
  static const ROUTE_NAME = 'contacts';

  final ContactBloc _contactBloc;

  const ContactsScreen(this._contactBloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _contactBloc..add(LoadContacts()),
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          return BaseLayout(
            appBar: CupertinoNavigationBar(
              middle: Text(
                'Contacts',
                style: TextStyle(color: Theme.of(context).kTextColor),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).kTextColor,
                ),
                onPressed: () async {
                  await Navigator.pushNamed(context, CreateContactScreen.ROUTE_NAME);
                  if (context.mounted) {
                    context.read<ContactBloc>().add(LoadContacts());
                  }
                },
              ),
              transitionBetweenRoutes: true,
              backgroundColor: Theme.of(context).kBackgroundColor,
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContactState state) {
    if (state is ContactLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ContactError) {
      return Center(
        child: Text(
          state.message,
          style: TextStyle(color: Theme.of(context).kAlertDangerColor),
        ),
      );
    }

    if (state is ContactLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<ContactBloc>().add(LoadContacts());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: state.contacts.isEmpty
                ? Center(
                    child: Text(
                      'No contacts yet. Add your first contact!',
                      style: TextStyle(color: Theme.of(context).kTextColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = state.contacts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ContactDetailsScreen.ROUTE_NAME,
                            arguments: {ContactDetailsScreen.CONTACT_ARG: contact},
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).kBackgroundColorLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).kPrimaryColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      contact.name,
                                      style: TextStyle(
                                        color: Theme.of(context).kTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatWallet(contact.wallet),
                                      style: TextStyle(
                                        color: Theme.of(context).kTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _deleteContact(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Contact',
          style: TextStyle(color: Theme.of(context).kTextColor),
        ),
        content: Text(
          'Are you sure you want to delete ${contact.name}?',
          style: TextStyle(color: Theme.of(context).kTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).kTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ContactBloc>().add(DeleteContact(id: contact.wallet));
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).kAlertDangerColor),
            ),
          ),
        ],
      ),
    );
  }
} 