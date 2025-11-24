import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final String description;

  const WarningDialog({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Peringatan",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(description),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
