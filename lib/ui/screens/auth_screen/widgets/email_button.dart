import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';

class EmailButton extends StatelessWidget {
  const EmailButton({
    super.key,
    required this.assetPath,
  });

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(GoogleSignInEvent());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xffD5EFEE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          assetPath,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
