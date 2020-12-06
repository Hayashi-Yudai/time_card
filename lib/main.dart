import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecard/components/timer.dart';
import 'package:timecard/components/action_button.dart';
import 'package:timecard/request/post_gas.dart';

Future<void> main() async {
  try {
    await DotEnv().load('.env');
  } on Exception catch (_) {}
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
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const MyHomePage(),
        '/setting': (BuildContext context) => InitSettingForm(),
      },
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

  Future<void> _updateDatetime() async {
    final actionText = isEntering ? 'exit' : 'enter';
    final now = DateTime.now();
    final pref = await SharedPreferences.getInstance();

    await Request(now, pref.getString('username') ?? 'anonymous', actionText)
        .post(context);

    await pref.setBool('isEntering', !isEntering);

    setState(() {
      _datetime = DateTime.now();
      isEntering = !isEntering;
    });
  }

  @override
  void initState() {
    super.initState();

    Future(() async {
      final pref = await SharedPreferences.getInstance();

      final entering = pref.getBool('isEntering');
      final username = pref.getString('username');

      if (username == null) {
        await Navigator.of(context).pushNamed('/setting');
      }

      setState(() {
        isEntering = entering ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour = _datetime.hour.toString().padLeft(2, '0');
    final minutes = _datetime.minute.toString().padLeft(2, '0');
    final second = _datetime.second.toString().padLeft(2, '0');

    final buttonText = isEntering ? 'Exit the room' : 'Enter the room';

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/setting');
            })
      ]),
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

class InitSettingForm extends StatefulWidget {
  @override
  InitSettingFormState createState() {
    return InitSettingFormState();
  }
}

class InitSettingFormState extends State<InitSettingForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future(() async {
      final pref = await SharedPreferences.getInstance();

      setState(() {
        controller.text = pref.getString('username');
      });
    });
  }

  void setUserName(String username) {
    if (_formKey.currentState.validate()) {
      Future(() async {
        final pref = await SharedPreferences.getInstance();
        await pref.setString('username', username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Setting'),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              validator: (val) {
                if (val.isEmpty) {
                  return 'User name should not be empty';
                }
                return null;
              },
            ),
            ActionButton('Apply', () {
              setUserName(controller.text);
              Navigator.of(context).pop();
            }),
          ]),
        ),
      ),
    );
  }
}
