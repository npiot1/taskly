import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/providers/user.dart';
import 'package:taskly/framework/repositories/auth_repository.dart';
import 'package:taskly/framework/utils/date.dart';
import 'package:taskly/framework/widgets/button.dart';
import 'package:taskly/main.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final auth = ref.watch(authStateProvider);

    return Drawer(
      child: user.when(
        data:
            (user) => Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: ApplicationColors.MAIN_COLOR,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        user.photoUrl != null
                            ? CircleAvatar(
                              backgroundImage: NetworkImage(user.photoUrl!),
                              radius: 40,
                            )
                            : CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.person, size: 40),
                            ),
                        SizedBox(height: 10),
                        Text(user.pseudo),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "mail : ${auth.value?.email}",
                            ),
                                                        Text(
                              "account created : ${user.createdAt.toSpokenLanguage()}",
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      AppButton(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        color: ApplicationColors.MAIN_COLOR,
                        text: "Logout",
                        action: () {
                          var auth = ref.read(authRepositoryProvider);
                          auth
                              .logout()
                              .then((value) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBar(content: Text("Logout successful")),
                                );
                              })
                              .catchError((error) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text("Logout failed: $error"),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Text("Erreur : $e"),
      ),
    );
  }
}
