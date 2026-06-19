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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool canLogin = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        alignment: Alignment.topRight,
        description: const Text('Please fill in all fields correctly'),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => _isLoading = true);

    final error = await AuthService.instance.login(email, password);

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
                      SizedBox(
                        height: 200,
                        child: Lottie.asset('assets/images/login.json'),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Login Account',
                        textAlign: TextAlign.left,
                        style: CustomTextstyles.b24Bold,
                      ),
                      Text(
                        'Access your notes securely',
                        textAlign: TextAlign.left,
                        style: CustomTextstyles.g12400,
                      ),
                      const SizedBox(height: 32),

                      AppTextField(
                        label: "Email Address",
                        hintText: 'example@gmail.com',
                        controller: emailController,
                        validator: AppValidators.email,
                        onChanged: (value) {
                          setState(() {
                            canLogin =
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      AppTextField(
                        hintText: '***',
                        controller: passwordController,
                        obscure: true,
                        onChanged: (value) {
                          setState(() {
                            canLogin =
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty;
                          });
                        },
                        validator: (value) => AppValidators.required(
                          value,
                          fieldName: "Password",
                        ),
                        label: 'Password',
                      ),
                      const SizedBox(height: 40),

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
                              label: _isLoading ? 'Logging in...' : 'Login',
                              onPressed: (canLogin && !_isLoading)
                                  ? () async {
                                      await _handleLogin();
                                    }
                                  : null,
                            ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: CustomTextstyles.g12400,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Sign Up',
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
