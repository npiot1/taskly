library login;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/framework/business/result.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/repositories/auth_repository.dart';
import 'package:taskly/framework/widgets/button.dart';
import 'package:taskly/framework/widgets/input.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('Login')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                color: ApplicationColors.GREY_2,
                                text: "Login",
                                action: () async {
                                  final auth = ref.read(authRepositoryProvider);
                                  var res = await auth.login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  res.showNotification();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Doesn't have an account ?",
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
                              text: "Sign up",
                              action: () {
                                context.push('/signup');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
