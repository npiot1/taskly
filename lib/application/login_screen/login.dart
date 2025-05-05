library login;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/framework/auth/auth_provider.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/widgets/button.dart';
import 'package:taskly/framework/widgets/input.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Login')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/logo.jpeg'),
                  ),
                  CustomTextInput(
                    controller: emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    textSize: AppFontSize.XXLARGE_TEXT,
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    controller: passwordController,
                    label: "Password",
                    hintText: "******",
                    obscureText: true,
                    textSize: AppFontSize.XXLARGE_TEXT,
                  ),
                  const SizedBox(height: 24),
                  Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        color: ApplicationColors.GREY_2,
                        text: "Login",
                        action: () async {

                          final auth = ref.read(authRepositoryProvider);
                          try {
                            var u = await auth.login(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            if (u != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Connected !'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error : Invalid credentials',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error : ${e.toString()}'),
                              ),
                            );
                          }

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        "Doesn't have an account ?",
                        style: TextStyle(
                          fontSize: AppFontSize.XLARGE_TEXT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(20),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          color: ApplicationColors.GREY_2,
                          text: "Sign up",
                          action: () {
                            context.push('/signup');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
