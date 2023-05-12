import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

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
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your Email here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              ///here we create a user in firebase after taking the input from the user from app
              //// we use try catch block here as we are expecting error from firebase related issues so we put this block here
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(userCredential);

                ///here we can write this code to target specific exceptions in the code of try which we are expecting to have error
              } on FirebaseAuthException catch (e) {
                ///can also use catch to target all errors in try block
                print(e.code);
                if (e.code == "user-not-found") {
                  print("User not found");
                } else if (e.code == "wrong-password") {
                  print("wrong password");
                }
              }
            },
            child: const Text("Login"),
          ),

          ///here we are creating another button for navigating to our register view for those users who dont have an account
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/register/",
                (route) => false,
              );
            },
            child: const Text("Not registered yet? Register here !"),
          )
        ],
      ),
    );
  }
}
