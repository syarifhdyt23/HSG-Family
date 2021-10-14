import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/login/login.dart';
import 'package:hsgfamily/run.dart';
import 'package:hsgfamily/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSG Family',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.black.withOpacity(.8),
        appBarTheme: new AppBarTheme(
          color: Colors.white,
          textTheme: new TextTheme(title: new TextStyle(color: Colors.black, fontSize: 19)),
          iconTheme: new IconThemeData(color: Colors.black)
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String message, identifier, deviceId;
  List dataJson;
  Timer timer;
  Domain domain = new Domain();
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<void> getDevice() async {
    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      identifier = androidInfo.androidId.toString();
      deviceId = "android";
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      identifier = iosInfo.identifierForVendor.toString();
      deviceId = "ios";
    }
  }

  Future<void> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/loaddata.php?action=getLogin&param=" +identifier),
        headers: { "Accept": "application.json"}
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['emp_id'];

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getDevice();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => this.getData());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: message == null ? new SplashScreen() :
      message != '1' ? new Run(empId: message, empname: dataJson[0]['emp_name'],) : new Login(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
