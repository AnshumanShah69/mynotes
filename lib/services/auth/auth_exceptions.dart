class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class GenericAuthException implements Exception {}

///this is for the exceptions when the firbase throws exception other than the above mentioned (only for firebase etc exeptions) or any other exceptions except firebaseauth category

class UserNotLoggedInAuthException implements Exception {}///is for firebase provider to throw if in database the value of the user is still null after the user send has already logged in the app
