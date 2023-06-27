import "package:mynotes/services/auth/auth_exceptions.dart";
import "package:mynotes/services/auth/auth_provider.dart";
import "package:mynotes/services/auth/auth_user.dart";
import "package:test/test.dart";

///here we we will be creating our own mock authprovider for testing purpose.
/// initialization is the first step if not throw exception in every function
void main() {
  //here we are creating our test groups for grouping each unit and then testing them in group
  group("mock authentication", () {
    final provider = MockAuthProvider();
    //here we are creating the instance of our mockauthprovider
    ///now we will write our first test
    ///provider should not be initialized and should be false at the very beginning(assumption)
    test("should not be initialized to begin with ", () {
      expect(provider.isInitialized, false); //T1
    });

    test("cannot logout if not initialized", () {
      //T2
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("should be able to initialize", () async {
      //T3
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    //T4
    test("user should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    //T5
    test(
      //T6
      "should be able to initialize less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test(
        //T7
        "create user should delegate to logIn function", () async {
      final badEmailUser = provider.createUser(
        email: "foo@bar.com",

        ///right email
        password: "anypassword", //wrong password
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: "soemone@bar.com", //wrong email
        password: "foobar",

        ///right password
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "foo",

        ///both wrong or different from the assumed values
        password: "bar",
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logging in user should be able to get verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("should be able to log out and log in again", () async {
      await provider.logOut();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  ///here we are creating initialized an isInitialized e variable because we are gonna check first if the
  AuthUser? _user;

  ///here we initialize the user and use it everywhere
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    ///this initializes our provider (1st step) it is inbuilt in firebase but not here so first we check whether its initialized or not and then move to the isInitialized variable (not there in mock AP)
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;

    ///here after initialization we set the flag as true
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();

    ///here we have taken sample email to do use test
    if (password == "foobar") throw WrongPasswordAuthException();

    ///here we have taken sample pass for testing
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;

    ///here we are again initializing the user as we cant use the main declared user to emailver as true so we again initialize the same
    if (user == null) throw UserNotFoundAuthException();

    ///here if
    ///here we create a new user and set the value of emailver as true
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;

    ///and set the current user as the new user
  }
}
