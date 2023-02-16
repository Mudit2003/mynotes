import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'please wait a moment',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: false);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  // bool ==() // what overriding can equatable could do it better
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingtext,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingtext,
        );

  @override
  List<Object?> get props => [exception, isLoading];
  // @override  // we could have done this too but equatable made it easier
  // bool operator ==(covariant AuthStateLoggedOut other) =>
  //     exception == other.exception && isLoading == other.isLoading;

  //       @override
  //       int get hashCode => exception.hashCode ^ isLoading.hashCode; // the issue that arises is how will you differ the hashcode
  //       // I am chosing to user xor in this code
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}
