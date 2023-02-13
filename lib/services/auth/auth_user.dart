// import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable // tells that internals are never gonna be changed upon inititialization of the class or the subclass all constant fields
class AuthUser {
  final String email; // email parameter should not be optional in our application but it could be for a phone number based authentiacation system 

  final bool isEmailVerified;
  final String id;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid,
      );
}
