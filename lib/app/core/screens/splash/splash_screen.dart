import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/core/domain/services/secure_storage_service.dart';
import 'package:tokenai/app/core/navigation/route_navigator.dart';
import 'package:tokenai/app/core/screens/main/main_screen.dart';
import 'package:tokenai/app/auth/screens/signin/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  static const ROUTE_NAME = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStoredKeys();
  }

  Future<void> _checkStoredKeys() async {
    final secureStorageService = GetIt.I.get<SecureStorageService>();
    final storedKeys = await secureStorageService.getAllKeys();

    if (storedKeys['secretKey'] != null && storedKeys['publicKey'] != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.ROUTE_NAME,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.ROUTE_NAME,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
