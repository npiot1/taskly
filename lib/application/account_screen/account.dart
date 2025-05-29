import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/account_screen/account_controller.dart';
import 'package:taskly/framework/business/result.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/widgets/button.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    final appUser = ref.watch(
      accountControllerProvider.select((state) => state.user),
    );
    final authUser = ref.watch(currentAuthUserProvider);
    final taskState = ref.watch(
      accountControllerProvider.select((state) => state.state),
    );

    final emailController = TextEditingController(text: authUser!.email);
    final pseudoController = TextEditingController(text: appUser.pseudo);
    final photoController = TextEditingController(text: appUser.photoUrl ?? '');
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (taskState is TaskLoading) return;
            context.pop();
            ref.read(accountControllerProvider.notifier).initState();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You must verify your email after changing it to be considered.',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: pseudoController,
                decoration: const InputDecoration(labelText: 'Pseudo'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Pseudo required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: photoController,
                decoration: const InputDecoration(
                  labelText: 'Photo URL (optional)',
                  hintText: 'Enter a URL for your profile photo',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  color: ApplicationColors.MAIN_COLOR,
                  colorText: ApplicationColors.WHITE,
                  text: 'Save Changes',
                  action:
                      taskState is TaskLoading
                          ? null
                          : () async {
                            if (!formKey.currentState!.validate()) return;

                            final controller = ref.read(
                              accountControllerProvider.notifier,
                            );

                            var confirmResult = Result.success();
                            if (emailController.text != authUser.email ||
                                passwordController.text.isNotEmpty) {
                              await askPassword(context).then((password) async {
                                if (password.isFailure) {
                                  confirmResult = Result.failure(
                                    password.errorMessage!,
                                  );
                                  return;
                                } else {
                                  final reAuthResult = await controller
                                      .reAuthenticate(password.data!);
                                  if (reAuthResult.isFailure) {
                                    confirmResult = Result.failure(
                                      reAuthResult.errorMessage!,
                                    );
                                    return;
                                  }
                                }
                              });
                            }

                            if (confirmResult.isFailure) {
                              confirmResult.showNotification();
                              return;
                            }

                            Result emailResult = const Result.success();
                            if (emailController.text != authUser.email) {
                              controller.updateEmailState(emailController.text);
                              emailResult = await controller.updateEmail();
                            }

                            Result passwordResult = const Result.success();
                            if (passwordController.text.isNotEmpty) {
                              controller.updatePasswordState(
                                passwordController.text,
                              );
                              passwordResult =
                                  await controller.updatePassword();
                            }

                            controller.updatePseudo(pseudoController.text);
                            controller.updatePhotoUrl(photoController.text);
                            final userResult = await controller.updateUser();

                            if (emailResult.isFailure) {
                              emailResult.showNotification();
                            } else if (passwordResult.isFailure) {
                              passwordResult.showNotification();
                            } else if (userResult.isFailure) {
                              userResult.showNotification();
                            } else {
                              Result.success(
                                null,
                                'Account updated successfully',
                              ).showNotification();
                              context.pop();
                            }
                          },
                  buttonState: taskState,
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Danger Zone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      color: Colors.red,
                      colorText: ApplicationColors.WHITE,
                      text: 'Delete Account',
                      action: () async {
                        final passwordResult = await askPassword(context);
                        final controller = ref.read(
                          accountControllerProvider.notifier,
                        );
                        if (passwordResult.isFailure) {
                          passwordResult.showNotification();
                          return;
                        } else {
                          final reAuthResult = await controller.reAuthenticate(
                            passwordResult.data!,
                          );
                          if (reAuthResult.isFailure) {
                            Result.failure(
                              reAuthResult.errorMessage!,
                            ).showNotification();
                            return;
                          }
                        }

                        final result = await controller.deleteAccount(
                          passwordResult.data!,
                        );
                        if (result.isSuccess) {
                          Result.success(
                            null,
                            "Account deleted",
                          ).showNotification();
                          context.go('/');
                        } else {
                          result.showNotification();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
