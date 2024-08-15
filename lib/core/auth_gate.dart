import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/login_and_register/login/view/login_page.dart';
import 'package:recipe_app/login_and_register/register/view/login_page.dart';
import 'package:recipe_app/login_and_register/toggle_auth/toggle_auth_cubut.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AuthGate());
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<ToggleAuthCubut>(context, listen: true).state) {
      return const LoginPage();
    } else {
      return const RegisterPage();
    }
  }
}
