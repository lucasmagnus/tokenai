import 'package:flutter/material.dart';
import 'package:tokenai/app/core/navigation/route_navigator.dart';

import 'sign_up_template.dart';

class SignUpScreen extends StatelessWidget {
  static const ROUTE_NAME = 'sign-up-profile';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpTemplate(
      onSignInPressed: () => RouteNavigator.pop(),
      onNextPressed: (String name, String email) {
      },
    );
  }
}
