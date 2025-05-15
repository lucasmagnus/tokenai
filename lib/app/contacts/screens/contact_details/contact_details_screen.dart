import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/contacts/domain/models/contact.dart';
import 'package:tokenai/app/contacts/screens/make_payment/make_payment_screen.dart';
import 'package:tokenai/components/atoms/button.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';

class ContactDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = 'contact-details';
  static const CONTACT_ARG = 'contact';

  final ContactBloc _contactBloc;
  final Contact contact;

  const ContactDetailsScreen(
    this._contactBloc, {
    required this.contact,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contactBloc,
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          return BaseLayout(
            appBar: CupertinoNavigationBar(
              middle: Text(
                'Contact Details',
                style: TextStyle(color: Theme.of(context).kTextColor),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, size: 24),
                onPressed: () => _deleteContact(context),
              ),
              transitionBetweenRoutes: true,
              backgroundColor: Theme.of(context).kBackgroundColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).kBackgroundColorLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).kPrimaryColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Theme.of(context).kTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          contact.name,
                          style: TextStyle(
                            color: Theme.of(context).kTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Public Key',
                          style: TextStyle(
                            color: Theme.of(context).kTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          contact.wallet,
                          style: TextStyle(
                            color: Theme.of(context).kTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Button(
                    label: "Copy Public Key",
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: contact.wallet));
                    },
                    type: ButtonType.TERTIARY,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 24),
                  Button(
                    label: "Make Payment",
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        MakePaymentScreen.ROUTE_NAME,
                        arguments: {MakePaymentScreen.CONTACT_ARG: contact},
                      );
                    },
                    type: ButtonType.PRIMARY,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteContact(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                  context.read<ContactBloc>().add(
                    DeleteContact(id: contact.wallet),
                  );
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to contacts list
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
