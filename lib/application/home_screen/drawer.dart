import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/business/result.dart';
import 'package:taskly/framework/constants/app_style.dart';
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
    final user = ref.watch(currentAppUserProvider);
    final auth = ref.watch(authStateProvider);

    return Drawer(
      child: user.when(
        data: (user) {
          if (user == null) {
            return const Expanded(
              child: Center(
                child: Text("user not found"),
              ),
            );
          }
          return Column(
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
                      Text(
                        user.pseudo,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.XLARGE_TEXT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(Icons.email, color: ApplicationColors.MAIN_COLOR),
                            title: Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.LARGE_TEXT,
                              ),
                            ),
                            subtitle: Text(
                              auth.value?.email ?? "Not available",
                              style: TextStyle(fontSize: AppFontSize.MEDIUM_TEXT),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.calendar_today, color: ApplicationColors.MAIN_COLOR),
                            title: Text(
                              "Account Created",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.LARGE_TEXT,
                              ),
                            ),
                            subtitle: Text(
                              user.createdAt.toSpokenLanguage(),
                              style: TextStyle(fontSize: AppFontSize.MEDIUM_TEXT),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              icon: Icon(Icons.account_circle, size: 20, color: Colors.white),
                              isIconLeading: true,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: ApplicationColors.MAIN_COLOR,
                              text: "Account",
                              colorText: ApplicationColors.WHITE,
                              action: () {
                                Navigator.pushNamed(context, '/account');
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              icon: Icon(Icons.settings, size: 20, color: Colors.white),
                              isIconLeading: true,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: ApplicationColors.MAIN_COLOR,
                              text: "Settings",
                              colorText: ApplicationColors.WHITE,
                              action: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              icon: Icon(Icons.logout, size: 20, color: Colors.white),
                              isIconLeading: true,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.red,
                              text: "Logout",
                              colorText: ApplicationColors.WHITE,
                              action: () {
                                var auth = ref.read(authRepositoryProvider);
                                auth.logout().then((value) {
                                  value.showNotification();
                                }).catchError((error) {
                                  scaffoldMessengerKey.currentState?.showSnackBar(
                                    SnackBar(
                                      content: Text("Logout failed: $error"),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Expanded(child: Text("Erreur : $e")),
      ),
    );
  }
}
