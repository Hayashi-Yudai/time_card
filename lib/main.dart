import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Time Card'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _datetime = DateTime.now();
  bool isEntering = false;

  void _updateDatetime() {
    final actionText = isEntering ? 'exit' : 'enter';
    final now = DateTime.now();

    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');

    final gas = DotEnv().env['GAS_URL'];

    final url = 'https://script.google.com/macros/s/$gas/exec';
    http.post(url, body: {
      'name': 'hayashi',
      'date': '$year-$month-$day',
      'time': '$hour:$minutes',
      'action': '$actionText',
    }).then((response) async {
      if (response.statusCode == 302) {
        openDialog(context);

        await Future<void>.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      } else {
        openErrorDialog(context, response.statusCode);
      }
    });

    setState(() {
      _datetime = DateTime.now();
      isEntering = !isEntering;
    });
  }

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
              title: Text('$statusCode'),
              children: const [],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final hour = _datetime.hour.toString().padLeft(2, '0');
    final minutes = _datetime.minute.toString().padLeft(2, '0');
    final second = _datetime.second.toString().padLeft(2, '0');

    final buttonText = isEntering ? 'Exit the room' : 'Enter the room';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Timer(20, '$hour:$minutes:$second', context),
            ButtonTheme(
              minWidth: 200,
              height: 60,
              child: RaisedButton(
                onPressed: _updateDatetime,
                child: Text(buttonText, style: const TextStyle(fontSize: 18)),
                highlightColor: Colors.blue,
                color: Colors.blue[50],
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
