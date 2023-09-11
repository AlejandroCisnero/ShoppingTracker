import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnBackAlertPopUp extends StatelessWidget {
  const OnBackAlertPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: const Text('Salir?'),
        content: const Text('Todos tus cambios se perderan'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Si'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    } else {
      return AlertDialog(
          title: const Text('Salir?'),
          content: const Text('Todos tus cambios se perderan'),
          actions: [
            TextButton(
              child: const Text('Si'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ]);
    }
  }
}
