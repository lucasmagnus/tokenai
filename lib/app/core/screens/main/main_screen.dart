import 'package:flutter/material.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/chat/screens/chat/chat_screen.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/contacts/screens/contact_list/contacts_screen.dart';
import 'package:tokenai/app/core/screens/home/home_screen.dart';
import 'package:tokenai/app/core/screens/profile/profile_screen.dart';

import 'main_template.dart';

class MainScreen extends StatelessWidget {
  static const ROUTE_NAME = 'main';

  final AssetBloc _assetBloc;
  final ContactBloc _contactBloc;

  const MainScreen(this._assetBloc, this._contactBloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      pages: [
        HomeScreen(_assetBloc),
        const ChatScreen(),
        ContactsScreen(_contactBloc),
        const ProfileScreen(),
      ],
    );
  }
}
