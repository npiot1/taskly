import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskly/framework/business/result.dart';

ImageProvider buildProfileImage(String imagePathOrUrl) {
  if (imagePathOrUrl.startsWith('http')) {
    return NetworkImage(imagePathOrUrl);
  } else {
    return FileImage(File(imagePathOrUrl));
  }
}

Future<Result<String>> askPassword(BuildContext context) async {
  final controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Confirm your password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final password = controller.text.trim();
                Navigator.pop(context, password.isNotEmpty ? password : null);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
  );

  if (result != null) {
    return Result.success(result);
  } else {
    return const Result.failure("Confirmation canceled or empty password");
  }
}

String? formatDescription(String description) {
  return description.trim().isEmpty || description.trim().replaceAll(RegExp(r'\s+'), '').isEmpty ? null : description.trim();
}
