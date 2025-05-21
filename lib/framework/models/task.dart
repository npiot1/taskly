import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskly/framework/models/converters/timestamp_converter.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    String? id,
    required bool completed,
    @Default("") String description,
    @TimestampConverter() required DateTime dueDate,
    required String name,
    required int priority,
    required String userId,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}