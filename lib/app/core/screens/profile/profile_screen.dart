import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/core/domain/services/secure_storage_service.dart';
import 'package:tokenai/app/auth/screens/signin/sign_in_screen.dart';
import 'package:tokenai/components/atoms/button.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tokenai/constants/all.dart';

class ProfileScreen extends StatelessWidget {
  static const ROUTE_NAME = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(color: Theme.of(context).kTextColor),
        ),
        transitionBetweenRoutes: true,
        backgroundColor: Theme.of(context).kBackgroundColor,
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: GetIt.I.get<SecureStorageService>().getAllKeys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.error_loading_profile,
                style: TextStyle(color: Theme.of(context).kAlertDangerColor),
              ),
            );
          }

          final publicKey = snapshot.data?['publicKey'];
          if (publicKey == null) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_public_key_found,
                style: TextStyle(color: Theme.of(context).kAlertDangerColor),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).kBackgroundColorLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).kPrimaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.public_key,
                        style: TextStyle(
                          color: Theme.of(context).kTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        publicKey,
                        style: TextStyle(
                          color: Theme.of(context).kTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Button(
                  label: "Copy Public Key",
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: publicKey));
                  },
                  type: ButtonType.TERTIARY,
                  fullWidth: true,
                ),
                const SizedBox(height: 24),
                Button(
                  label: AppLocalizations.of(context)!.logout,
                  fullWidth: true,
                  type: ButtonType.TERTIARY,
                  onPressed: () async {
                    await GetIt.I.get<SecureStorageService>().clearAllKeys();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.ROUTE_NAME,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
