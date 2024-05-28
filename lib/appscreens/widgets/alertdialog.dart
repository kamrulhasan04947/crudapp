import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.onTap
  });
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content:
      Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('Yes, Delete'),
        ),
      ],
    );
  }
}

