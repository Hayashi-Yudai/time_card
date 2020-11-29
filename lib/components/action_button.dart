import 'package:flutter/material.dart';

class ActionButton extends RaisedButton {
  ActionButton(String buttonText, Function func)
      : super(
          onPressed: () {
            func();
          },
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
          highlightColor: Colors.blue,
          color: Colors.blue[50],
          elevation: 8,
        );
}
