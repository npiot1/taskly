library signup;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/widgets/button.dart';
import 'package:taskly/framework/widgets/input.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Sign Up')),
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
                  CustomTextInput(
                    controller: usernameController,
                    label: "Pseudo",
                    hintText: "Choose your username",
                    textSize: AppFontSize.XXLARGE_TEXT,
                  ),
                  const SizedBox(height: 16),
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
                    hintText: "Create a password",
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
                        text: "Sign Up",
                        action: () {
                          // TODO: implémenter l'action
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
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: AppFontSize.XLARGE_TEXT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          color: ApplicationColors.GREY_2,
                          text: "Login",
                          action: () {
                            context.pop();
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
