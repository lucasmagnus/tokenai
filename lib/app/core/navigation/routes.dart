import 'package:flutter/material.dart';
import 'package:tokenai/app/asset/routes.dart';
import 'package:tokenai/app/auth/routes.dart';
import 'package:tokenai/app/contacts/routes.dart';
import 'package:tokenai/app/core/routes.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  ...authRoutes,
  ...coreRoutes,
  ...assetRoutes,
  ...ContactsRoutes.getRoutes(),
};
