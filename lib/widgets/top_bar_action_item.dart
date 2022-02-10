import 'package:flutter/material.dart';

class TopBarActionItem extends StatelessWidget {
  TopBarActionItem(
      {this.buttonIcon = Icons.help_outline_rounded,
      required this.onPressedAction});

  final IconData buttonIcon;
  final Function onPressedAction;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(buttonIcon),
      onPressed: () => onPressedAction,
    );
  }
}
