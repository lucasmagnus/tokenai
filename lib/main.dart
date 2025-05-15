import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tokenai/app/core/screens/splash/splash_screen.dart';

import 'app/core/di/modules.dart';
import 'app/core/navigation/route_navigator.dart';
import 'app/core/navigation/routes.dart';
import 'constants/theme.dart';

Future main() async {
  startGetItModules();

  await GetIt.I.allReady();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokenAI',
      navigatorKey: RouteNavigator.navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: routes,
      theme: themeLight,
      darkTheme: themeDark,
      initialRoute: SplashScreen.ROUTE_NAME,
    );
  }
}
