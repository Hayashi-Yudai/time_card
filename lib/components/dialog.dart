import 'package:flutter/material.dart';

void openDialog(BuildContext context) {
  showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => const SimpleDialog(
            title: Text('OK'),
            children: [],
          ));
}

void openErrorDialog(BuildContext context, int statusCode) {
  showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
            title: Text('Error: $statusCode'),
            children: const [],
          ));
}
