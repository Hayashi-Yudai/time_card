import 'package:flutter/material.dart';

class Timer extends Container {
  Timer(double margin, String text, BuildContext context)
      : super(
          margin: EdgeInsets.only(bottom: margin),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline4,
          ),
        );
}
