// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
// ignore: unused_import
import 'package:mynotes/views/login_views.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'firebase_options.dart';
// ignore: unused_import
import "dart:developer" as devtools show log;

///these are import statements

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

//here we are creating another sfl widget for our notes view
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main UI"), actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialogue(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
            }
          },
          itemBuilder: (context) {
            ///here itembuilder always takes return as a list and once we enter the popupmenuitem
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction
                    .logout, /////the value attribute values is passed to the onSelected function once we click on the logout dropdown(this is for the developer view)
                child: Text("Log out"),

                ///this is the user view and shows in dropdown
              ),
            ];
          },
        )
      ]),
      body: const Text("Hello World"),
    );
  }
}

Future<bool> showLogOutDialogue(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("sign out"),
        content: const Text("are you sure you want to sign out ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Log out"),
          ),
        ],
      );
    },
  ).then((value) =>
      value ??
      false); //the future has to be returned a value so if for example the user decides to not answer the question by clicking on the back button so we give default value as false or the action is taken and value is given through function
}
