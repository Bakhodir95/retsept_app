import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:retsept_app/ui/screens/auth_screen/screens/registor_screen.dart';
import 'package:retsept_app/ui/screens/auth_screen/widgets/email_button.dart';
import 'package:retsept_app/ui/screens/auth_screen/widgets/erroe_dialog.dart';
import 'package:retsept_app/ui/screens/auth_screen/widgets/forgot_password_dialog.dart';
import 'package:retsept_app/ui/screens/auth_screen/widgets/validator.dart';
import 'package:retsept_app/ui/screens/home_screen/widgets/bootom_nav_bar.dart';
import 'package:retsept_app/ui/widgets/leading_button.dart';
import 'package:retsept_app/ui/widgets/text_field_widget.dart';

enum ErrorType { network, authentication, validation, unknown }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showErrorDialog(String message, ErrorType errorType) {
    showDialog(
      context: context,
      builder: (ctx) => BeautifulErrorDialog(
        errorType: errorType,
        message: message,
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
            LoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MyBottomNavBar()),
      (route) => false,
    );
  }

  void _handleStateChanges(AuthState state) {
    setState(() {
      _isLoading = state is LoadingAuthState;
    });

    if (state is ErrorAuthState) {
      final errorType = state.message.contains("network")
          ? ErrorType.network
          : state.message.contains("EMAIL_EXISTS")
              ? ErrorType.authentication
              : state.message.contains("valid")
                  ? ErrorType.validation
                  : ErrorType.unknown;

      _showErrorDialog(state.message, errorType);
    }

    if (state is AuthenticatedAuthState) {
      _navigateToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => _handleStateChanges(state),
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.white)),
          Positioned(
            child: Image.asset(
              "assets/auth_image/top_left.png",
              height: MediaQuery.of(context).size.height / 2,
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leadingWidth: 70,
              leading: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: LeadingButton(
                  radius: 15,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          controller: _emailController,
                          title: 'Email',
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          controller: _passwordController,
                          title: 'Password',
                          validator: passwordValidator,
                          obscureText: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              showForgotPasswordDialog(context);
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const Gap(80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xff3FB4B1),
                    fixedSize: Size(MediaQuery.of(context).size.width, 60),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: EmailButton(
                        assetPath: "assets/auth_image/google.png",
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      child: EmailButton(
                        assetPath: "assets/auth_image/apple.png",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
