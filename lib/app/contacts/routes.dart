import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/contacts/screens/contact_list/contacts_screen.dart';
import 'package:tokenai/app/contacts/screens/contact_details/contact_details_screen.dart';
import 'package:tokenai/app/contacts/screens/create_contact/create_contact_screen.dart';
import 'package:tokenai/app/contacts/screens/make_payment/make_payment_screen.dart';

class ContactsRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      ContactsScreen.ROUTE_NAME: (context) => ContactsScreen(GetIt.I.get<ContactBloc>()),
      CreateContactScreen.ROUTE_NAME: (context) => CreateContactScreen(GetIt.I.get<ContactBloc>()),
      ContactDetailsScreen.ROUTE_NAME: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return ContactDetailsScreen(
          GetIt.I.get<ContactBloc>(),
          contact: args[ContactDetailsScreen.CONTACT_ARG],
        );
      },
      MakePaymentScreen.ROUTE_NAME: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BlocProvider(
          create: (context) => GetIt.I.get<AssetBloc>(),
          child: MakePaymentScreen(
            GetIt.I.get<AssetBloc>(),
            args[MakePaymentScreen.CONTACT_ARG],
          ),
        );
      },
    };
  }
} 