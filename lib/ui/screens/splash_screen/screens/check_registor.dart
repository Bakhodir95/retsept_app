import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:retsept_app/ui/screens/auth_screen/screens/initial_screen.dart';
import 'package:retsept_app/ui/screens/home_screen/widgets/bootom_nav_bar.dart';

class CheckRegistor extends StatelessWidget {
  const CheckRegistor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: context.read<AuthBloc>()..add(CheckTokenExpiryEvent()),
        builder: (context, state) {
          if (state is AuthenticatedAuthState) {
            return const MyBottomNavBar();
          }
          return const InitialScreen();
        },
      ),
    );
  }
}
