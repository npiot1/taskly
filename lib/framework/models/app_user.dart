import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskly/framework/models/converters/timestamp_converter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
    const factory AppUser({
        required String pseudo,
        @TimestampConverter() required DateTime createdAt,
        String? photoUrl,
    }) = _AppUser;

    factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}