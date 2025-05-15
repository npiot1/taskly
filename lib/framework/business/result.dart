import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const Result._(); 

  const factory Result.success([T? data]) = Success<T>;
  const factory Result.failure(String message) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  String? get errorMessage => this is Failure<T> ? (this as Failure<T>).message : null;

}

