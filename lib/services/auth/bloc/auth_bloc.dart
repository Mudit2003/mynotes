import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut());
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(
              user)); // you cannot call a constant constructor with a variable
        }
      },
    );

    //login
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoading()); // logging in
        final String email = event.email;
        final String password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLogInFailure(e));
        }
      },
    );

    //logOut
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(const AuthStateLoading()); // logging out
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut());
        } on Exception catch (e) {
          emit(AuthStateLogOutFailure(e));
        }
      },
    );
  }
}
