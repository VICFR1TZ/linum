import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAlert {
  final BuildContext _context;

  UserAlert({required BuildContext context}) : _context = context;

  Future<void> showMyDialog2({
    String message = 'Ein unbekannter Fehler ist aufgetreten.',
    String title = 'Fehler',
    String actionTitle = 'Okay',
    bool userMustDismissWithButton = true,
  }) {
    return showMyDialog(message,
        title: title,
        actionTitle: actionTitle,
        userMustDismissWithButton: userMustDismissWithButton);
  }

  Future<void> showMyDialog(
    String message, {
    String title = 'Anmeldung nicht erfolgreich',
    String actionTitle = 'Okay',
    bool userMustDismissWithButton = false,
  }) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible:
          !userMustDismissWithButton, // user must tap button if userMustDismissWithButton is true
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(actionTitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}