import 'package:flutter/material.dart';

void main() {
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
      home: MyHomePage(title: 'Time Card'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _datetime = new DateTime.now();

  void _incrementCounter() {
    setState(() {
      _datetime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_datetime.hour}:${_datetime.minute}:${_datetime.second}',
              style: Theme.of(context).textTheme.headline4,
            ),
            ButtonTheme(
              minWidth: 200,
              height: 60,
              child: RaisedButton(
                onPressed: _incrementCounter,
                child: const Text('Enter the room',
                    style: TextStyle(fontSize: 18)),
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
