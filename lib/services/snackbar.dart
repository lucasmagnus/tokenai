import 'package:flutter/material.dart';
import 'package:tokenai/components/molecules/custom_snackbar.dart';
import 'package:tokenai/utils/errors/errors.dart';

class SnackBarService {
  final BuildContext context;

  SnackBarService.of(this.context);

  void success(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackbar(
        contentText: message,
        type: SnackbarType.SUCCESS,
        context: context,
      ),
    );
  }

  void error(exception, [message]) {
    final errorMessage = message ?? getErrorMessage(exception, context) ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackbar(
        contentText: errorMessage,
        type: SnackbarType.DANGER,
        context: context,
      ),
    );
  }
}
