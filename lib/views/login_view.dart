import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              // try {
              context.read<AuthBloc>().add(
                    AuthEventLogIn(
                      email,
                      password,
                    ),
                  );
              // final state = context.read<AuthBloc>().state;
              // if (state is AuthStateLogInFailure) {
              //   if (state.exception is UserNotFoundAuthException) {
              //     await showErrorDialogue(
              //       context,
              //       "User not found",
              //     );
              //   } else if (state.exception is WrongPasswordAuthException) {
              //     await showErrorDialogue(
              //       context,
              //       "Wrong Password",
              //     );
              //   } else if (state.exception is InavalidEmailAuthException) {
              //     await showErrorDialogue(
              //       context,
              //       "Invalid Email",
              //     );
              //   } else if (state.exception is GenericAuthException) {
              //     await showErrorDialogue(
              //       context,
              //       "Login Failed",
              //     );
              //   } else {
              //     await showErrorDialogue(
              //       context,
              //       "Login Failure",
              //     );
              //   }
              // }  // wasted code because all the listening is done in main 

              //   } on UserNotFoundAuthException catch (_) {
              // await showErrorDialogue(
              //   context,
              //   "User not found",
              // );
              //   } on WrongPasswordAuthException catch (_) {
              //     await showErrorDialogue(
              //       context,
              //       "Wrong credentials",
              //     );
              //   } on InavalidEmailAuthException catch (_) {
              //     await showErrorDialogue(
              //       context,
              //       "User Invalid",
              //     );
              //   } on GenericAuthException catch (_) {
              //     await showErrorDialogue(
              //       context,
              //       "Login Failed",
              //     );
              //   }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
