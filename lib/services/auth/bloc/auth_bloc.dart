import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(
            isLoading: true,
          ),
        ) {
    //send email verificaition
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        // emit(const AuthStateNeedsVerification());
        emit(state);
      },
    );

    // register
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
            isLoading: true,
          ));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(
          exception: null,
          isLoading: false,
        ));
      },
    );
    // initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      },
    );

    //login
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingtext: 'Please wait while we log you in',
        )); // logging in
        final String email = event.email;
        final String password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ));
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(const AuthStateNeedsVerification(isLoading: false));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );

    //logOut
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(exception: e, isLoading: false),
          );
        }
      },
    );

    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: false,
          ),
        );
        final email = event.email;
        if (email == null) {
          return; // user just wants to go to forgot password screen
        }

        // user actually wants to send a forgot password email
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: true,
          ),
        );

        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          // emit(
          //   AuthStateForgotPassword(
          //     exception: e,
          //     hasSentEmail: false,
          //     isLoading: false,
          //   ),
          // );
          didSendEmail = false;
          exception = e;
        }
        emit(
          AuthStateForgotPassword(
            exception: exception,
            hasSentEmail: didSendEmail,
            isLoading: false,
          ),
        );
      },
    );
  }
}
