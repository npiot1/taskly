library login;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/widgets/button.dart';
import 'package:taskly/framework/widgets/input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    controller: nameController,
                    label: "Pseudo",
                    hintText: "Enter your pseudo",
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
                        action: () {},
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
                          action: () {},
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
