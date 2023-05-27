//here we are creating another sfl widget for our notes view

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../enums/menu_action.dart';

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
                  await AuthService.firebase().logOut();
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
              Navigator.of(context).pop(true);
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
