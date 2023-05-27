///here we are creating this file to take the values from the provider file and integrate with services and provide to the UI and to the user for better utilization,
///
///////here the authservice file acts as the intermediary between the UI--authservice--firebase authentication
import "package:mynotes/services/auth/auth_provider.dart";
import "package:mynotes/services/auth/auth_user.dart";
import "package:mynotes/services/auth/firebase_auth_provider.dart";

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);
  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  ///here we are making this file as we cannot create an instance everytime we use a new user so we directly use the user here
  ///here the flow is auth_user->auth_provider(interface)->firebase_auth_provider->auth_service

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );
  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
