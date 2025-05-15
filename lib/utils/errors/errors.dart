import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnauthorizedException implements Exception {
  final String? message;

  const UnauthorizedException({this.message});
}

class BadRequestException implements Exception {
  final String? message;

  const BadRequestException(this.message);
}

class NoInternetConnectionException implements Exception {}

class ServerException implements Exception {}

class NotFoundException implements Exception {
  final String? message;

  const NotFoundException({this.message});
}

class UnknownException implements Exception {}

String? getErrorMessage(Exception? exception, BuildContext context) {
  if (exception is UnauthorizedException) {
    return exception.message ?? AppLocalizations.of(context)?.request_not_authorized_error;
  }

  if (exception is NoInternetConnectionException) {
    return AppLocalizations.of(context)?.network_error;
  }

  if (exception is ServerException) {
    return AppLocalizations.of(context)?.server_error;
  }

  if (exception is BadRequestException) {
    return exception.message;
  }

  if (exception is NotFoundException) {
    return AppLocalizations.of(context)?.not_found_error;
  }

  return AppLocalizations.of(context)?.unknown_error;
}
