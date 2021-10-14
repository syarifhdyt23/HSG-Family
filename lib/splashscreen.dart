import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flare_flutter/flare_actor.dart';

class SplashScreen extends StatefulWidget {

  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: new Stack(
        children: <Widget>[
          new Align(
            alignment: Alignment.center,
            child: new FlareActor('images/hsgloading.flr',
              alignment: Alignment.center, fit: BoxFit.contain, animation: 'loading-hsgfamily', ),
          ),

          new Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 30),
            child: new Text('HSG Family', style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 21),),
          )
        ],
      ),
    );
  }
}