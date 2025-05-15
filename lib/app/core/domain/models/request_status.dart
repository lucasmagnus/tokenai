import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RequestStatus<T> extends Equatable {
  const RequestStatus._();

  const factory RequestStatus.idle() = Idle;
  const factory RequestStatus.success(T? data) = Success;
  const factory RequestStatus.error({int? code, String? message, Exception? exception}) = Error;
  const factory RequestStatus.loading() = Loading;

  void when({
    VoidCallback? idle,
    void Function(T? data)? success,
    void Function(int? code, String? message, Exception? exception)? error,
    VoidCallback? loading,
  }) {
    if (this is Loading) {
      loading?.call();
    } else if (this is Success) {
      success?.call((this as Success).data);
    } else if (this is Error) {
      final data = this as Error;
      error?.call(data.code, data.message, data.exception);
    } else if (this is Idle) {
      idle?.call();
    }
  }

  @override
  List<Object?> get props => [];
}

class Idle<T> extends RequestStatus<T> {
  const Idle() : super._();

  @override
  List<Object?> get props => [];
}

class Success<T> extends RequestStatus<T> {
  final T? data;
  const Success(this.data) : super._();

  @override
  List<Object?> get props => [data];
}

class Error<T> extends RequestStatus<T> {
  final int? code;
  final String? message;
  final Exception? exception;

  const Error({this.code, this.message, this.exception}) : super._();

  @override
  List<Object?> get props => [code, message, exception];
}

class Loading<T> extends RequestStatus<T> {
  const Loading() : super._();

  @override
  List<Object?> get props => [];
}
