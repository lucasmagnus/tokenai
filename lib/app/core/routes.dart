import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/contacts/blocs/contact/contact_bloc.dart';
import 'package:tokenai/app/core/screens/home/home_screen.dart';
import 'package:tokenai/app/core/screens/main/main_screen.dart';
import 'package:tokenai/app/core/screens/profile/profile_screen.dart';
import 'package:tokenai/app/core/screens/splash/splash_screen.dart';

final Map<String, Widget Function(BuildContext)> coreRoutes = {
  SplashScreen.ROUTE_NAME: (context) => const SplashScreen(),
  MainScreen.ROUTE_NAME: (context) => MainScreen(GetIt.I.get<AssetBloc>(), GetIt.I.get<ContactBloc>()),
  HomeScreen.ROUTE_NAME: (context) => HomeScreen(GetIt.I.get<AssetBloc>()),
  ProfileScreen.ROUTE_NAME: (context) => const ProfileScreen(),
};
