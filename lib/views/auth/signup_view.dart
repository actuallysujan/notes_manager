import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_manager/core/app_buttons.dart';
import 'package:notes_manager/core/app_colors.dart';
import 'package:notes_manager/core/app_textfield.dart';
import 'package:notes_manager/core/custom_textstyles.dart';
import 'package:notes_manager/core/validators.dart';
import 'package:notes_manager/services/auth_service.dart';
import 'package:toastification/toastification.dart';
import '../../routes/app_routes.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => _isLoading = true);

    final error = await AuthService.instance.signup(name, email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        alignment: Alignment.topRight,
        description: Text(error),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  bool get canLogin =>
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      nameController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: appBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600 ? 450 : double.infinity,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      SizedBox(
                        height: 100,
                        child: Lottie.asset('assets/images/sign_up.json'),
                      ),
                      Row(
                        children: [
                          const Text(
                            'SignUp Account',
                            textAlign: TextAlign.left,
                            style: CustomTextstyles.b24Bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Join us to keep your notes organized',
                        textAlign: TextAlign.left,
                        style: CustomTextstyles.g12400,
                      ),
                      const SizedBox(height: 30),

                      // Input Fields
                      AppTextField(
                        label: "Name*",
                        hintText: 'Name',
                        validator: AppValidators.name,
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: "Email Address*",
                        hintText: 'Email Address',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: "Password*",
                        hintText: 'Password',
                        validator: AppValidators.password,
                        controller: passwordController,
                        obscure: true,
                        onChanged: (value) {
                          _formKey.currentState?.validate();

                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 12),
                      AppTextField(
                        label: "Confirm Password*",
                        hintText: 'Confirm Password',
                        controller: confirmPasswordController,
                        validator: (value) => AppValidators.confirmPassword(
                          value,
                          passwordController.text,
                        ),

                        obscure: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 40),

                      // Action Button
                      _isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: CircularProgressIndicator(
                                  color: AppColors.blackColor,
                                ),
                              ),
                            )
                          : ReusableElevatedButton(
                              label: _isLoading
                                  ? 'Registring...'
                                  : 'Create Account',
                              onPressed: (canLogin && !_isLoading)
                                  ? () async {
                                      await _handleSignup();
                                    }
                                  : null,
                            ),
                      const SizedBox(height: 10),

                      // Navigation to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: CustomTextstyles.g12400,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Login',
                              style: CustomTextstyles.b12600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
