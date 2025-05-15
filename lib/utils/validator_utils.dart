import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool validatePastedPin(String pinCode, int fields) =>
    RegExp(r'^[0-9]+$').hasMatch(pinCode) && pinCode.length == fields;

bool validateEmail(email) => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);

String? emailValidator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.empty_email_error;
  }

  if (!validateEmail(value)) {
    return AppLocalizations.of(context)!.invalid_email_error;
  }
  return null;
}

String? passwordValidator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.empty_password_error;
  }

  if (!RegExp(r'^(?=.*[0-9])').hasMatch(value)) {
    return AppLocalizations.of(context)!.password_must_contain_number_error;
  }

  if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
    return AppLocalizations.of(context)!.password_must_contain_lowercase_error;
  }

  if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
    return AppLocalizations.of(context)!.password_must_contain_uppercase_error;
  }

  if (!RegExp(r'^(?=.*[!@#$&*])').hasMatch(value)) {
    return AppLocalizations.of(context)!
        .password_must_contain_special_character_error;
  }

  if (value.length < 8 || value.length > 16) {
    return AppLocalizations.of(context)!.password_length_error;
  }
  return null;
}

String? confirmPasswordValidator(
  String? value,
  String? password,
  BuildContext context,
) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.empty_password_error;
  }

  if (value != password) {
    return AppLocalizations.of(context)!.password_must_match_error;
  }
  return null;
}

bool isPasswordValid(String? password) {
  if (password == null ||
      password.isEmpty ||
      !RegExp(r'^(?=.*[0-9])').hasMatch(password) ||
      !RegExp(r'^(?=.*[a-z])').hasMatch(password) ||
      !RegExp(r'^(?=.*[A-Z])').hasMatch(password) ||
      !RegExp(r'^(?=.*[!@#$&*])').hasMatch(password) ||
      password.length < 8 ||
      password.length > 16) {
    return false;
  }

  return true;
}
