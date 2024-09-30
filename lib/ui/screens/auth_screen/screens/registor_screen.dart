import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:retsept_app/ui/screens/account_setup_screens/screens/account_setup_screen.dart';
import 'package:retsept_app/ui/screens/auth_screen/screens/login_screen.dart';
import 'package:retsept_app/ui/screens/auth_screen/widgets/erroe_dialog.dart';
import 'package:retsept_app/ui/screens/auth_screen/widgets/validator.dart';
import 'package:retsept_app/ui/widgets/leading_button.dart';
import 'package:retsept_app/ui/widgets/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
            RegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is ErrorAuthState) {
          setState(() {
            _isLoading = false;
          });
          ErrorType errorType;
          if (state.message.contains("network")) {
            errorType = ErrorType.network;
          } else if (state.message.contains("EMAIL_EXISTS")) {
            errorType = ErrorType.authentication;
          } else if (state.message.contains("valid")) {
            errorType = ErrorType.validation;
          } else {
            errorType = ErrorType.unknown;
          }
          _showErrorDialog(state.message, errorType);
        }
        if (state is AuthenticatedAuthState) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AccountSetupScreen()),
            (route) => false,
          );
        }
      },
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
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          controller: _emailController,
                          title: 'Email',
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          controller: _passwordController,
                          title: 'Password',
                          obscureText: true,
                          validator: passwordValidator,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          controller: _passwordConfirmationController,
                          title: 'Confirm Password',
                          obscureText: true,
                          validator: _confirmPasswordValidator,
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
            bottom: 20,
            left: 15,
            right: 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xff3FB4B1),
                fixedSize: Size(MediaQuery.of(context).size.width, 60),
              ),
              onPressed: _submit,
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
