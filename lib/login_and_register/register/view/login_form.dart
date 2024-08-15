import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recipe_app/login_and_register/register/bloc/register_bloc.dart';
import 'package:recipe_app/login_and_register/toggle_auth/toggle_auth_cubut.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Registration Failure')),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.04),
                child: const Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let's help you set up your account, it won't take long.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.06),
              Column(
                children: [
                  SizedBox(height: height * 0.03),
                  _UsernameInput(),
                  SizedBox(height: height * 0.02),
                  _EmailInput(),
                  SizedBox(height: height * 0.02),
                  _PasswordInput(),
                  SizedBox(height: height * 0.02),
                  _ConfirmPasswordInput(),
                  SizedBox(height: height * 0.06),
                  _RegisterButton(),
                ],
              ),
              SizedBox(height: height * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member?'),
                  TextButton(
                    onPressed: () {
                      context.read<ToggleAuthCubut>().togglePage();
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (RegisterBloc bloc) => bloc.state.username.displayError,
    );

    return TextField(
      key: const Key('registerForm_usernameInput_textField'),
      onChanged: (username) {
        context.read<RegisterBloc>().add(RegisterUsernameChanged(username));
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Username',
        errorText: displayError != null ? 'Invalid username' : null,
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (RegisterBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('registerForm_emailInput_textField'),
      onChanged: (email) {
        context.read<RegisterBloc>().add(RegisterEmailChanged(email));
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Email',
        errorText: displayError != null ? 'Invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (RegisterBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      key: const Key('registerForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Password',
        errorText: displayError != null ? 'Invalid password' : null,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (RegisterBloc bloc) => bloc.state.confirmPassword.displayError,
    );

    return TextField(
      key: const Key('registerForm_confirmPasswordInput_textField'),
      onChanged: (confirmPassword) {
        context
            .read<RegisterBloc>()
            .add(RegisterConfirmPasswordChanged(confirmPassword));
      },
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Confirm Password',
        errorText: displayError != null ? 'Passwords do not match' : null,
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (RegisterBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);

    return ElevatedButton(
      key: const Key('registerForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.green,
      ),
      onPressed: isValid
          ? () => context.read<RegisterBloc>().add(const RegisterSubmitted())
          : null,
      child: const Text('Register'),
    );
  }
}
