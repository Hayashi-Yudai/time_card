import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timecard/components/timer.dart';
import 'package:timecard/components/action_button.dart';
import 'package:timecard/request/post_gas.dart';

Future<void> main() async {
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

    Request(now, 'hayashi', actionText).post(context);

    setState(() {
      _datetime = DateTime.now();
      isEntering = !isEntering;
    });
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
              child: ActionButton(
                buttonText,
                _updateDatetime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
