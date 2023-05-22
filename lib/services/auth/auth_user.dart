import 'package:firebase_auth/firebase_auth.dart' show User;
import "package:flutter/foundation.dart";

///we are making this file to avoid exposing our firbase code and functionality directly to the UI which is a good developer practice

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);

  ///here we have created a kind of copy of a user and placed the values of the original fetched firebase user details into our own made copy so to make sure we are not exposing the UI with our firebase
}
