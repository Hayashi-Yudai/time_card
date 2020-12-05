import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:timecard/components/dialog.dart';

class Request {
  Request(this.datetime, this.name, this.action);

  String action;
  DateTime datetime;
  String name;

  Map<String, String> makeJson() {
    final year = datetime.year.toString();
    final month = datetime.month.toString().padLeft(2, '0');
    final day = datetime.day.toString().padLeft(2, '0');
    final hour = datetime.hour.toString().padLeft(2, '0');
    final minutes = datetime.minute.toString().padLeft(2, '0');

    return {
      'name': name,
      'date': '$year-$month-$day',
      'time': '$hour:$minutes',
      'action': action,
    };
  }

  Future<void> post(BuildContext context) async {
    String gas;

    try {
      gas = DotEnv().env['GAS_URL'];
    } on Exception catch (_) {
      gas = const String.fromEnvironment(
          'GAS_URL'); // Platform.environment['GAS_URL'];
    }

    final url = 'https://script.google.com/macros/s/$gas/exec';
    await http.post(url, body: makeJson()).then((response) async {
      if (response.statusCode == 302) {
        openDialog(context);

        await Future<void>.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      } else {
        openErrorDialog(context, response.statusCode);
      }
    });
  }
}
