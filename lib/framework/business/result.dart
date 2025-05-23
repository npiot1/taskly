import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskly/main.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const Result._(); 

  const factory Result.success([T? data, String? message]) = Success<T>;
  const factory Result.failure(String message) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  String? get successMessage => this is Success<T> ? (this as Success<T>).message : null;
  String? get errorMessage => this is Failure<T> ? (this as Failure<T>).message : null;
}

extension ResultNotification<T> on Result<T> {
  void showNotification() {
    final scaffoldMessenger = scaffoldMessengerKey.currentState!;

    if (isSuccess) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: IntrinsicHeight(
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Success: ${successMessage ?? "Operation completed successfully"}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (isFailure) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: IntrinsicHeight(
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error: $errorMessage',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}