///it encapsulates all the possible provider for authentication in the future so we have made this file
/// here we also take the copy of the user we created in auth_user

import "package:mynotes/services/auth/auth_user.dart";

///we are amking this authprovider class abstract to serve this as a blueprint to various auth providers to work on our given user
///
//its actually a login function
abstract class AuthProvider {
  ////here we try to get the user from any auth provider....eg google,twitter,github etc
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  ////create user function for new users using various auth service providers to create new account

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  ///have to create a logout interface for the users with no return values

  Future<void> logOut();

  ///also for sending email verifications

  Future<void> sendEmailVerification();
}
