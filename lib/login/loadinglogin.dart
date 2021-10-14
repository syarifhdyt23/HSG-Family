import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/login/verification.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:hsgfamily/info.dart';

class LoadingLogin extends StatefulWidget {

  final String empid;

  LoadingLogin({this.empid});

  _LoadingLogin createState() => _LoadingLogin(empId: empid);
}

class _LoadingLogin extends State<LoadingLogin> {

  String empId, message;
  List dataJson;
  Size size;
  Timer timer;
  Domain domain = new Domain();
  Info info = new Info();

  _LoadingLogin({this.empId});

  Future<void> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/loaddata.php?action=getEmploye&param=" +empId),
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

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => this.getData());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      body: new Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: message == null ? new Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: new Stack(
              children: <Widget>[
                new Align(
                  alignment: Alignment.center,
                  child: new FlareActor('images/loading.flr',
                    alignment: Alignment.center, fit: BoxFit.contain, animation: 'loading', ),
                ),
              ],
            ),
          )
          :
          message != '1' ? Navigator.push(context, new MaterialPageRoute(builder: (context) => new Verification(empId: empId,)))
          :
          new Stack(
            children: <Widget>[
              new Positioned(
                left: .0,
                right: .0,
                top: 90,
                child: new Image.asset('images/noemp.png'),
              ),

              new Container(
                alignment: Alignment.center,
                child: new Text('Emp Id $empId not found'),
              ),

              new Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                  height: 45,
                  width: size.width - 50,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: new FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: new Text('Try Again', style: new TextStyle(color: Colors.white),),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(7.0),
                        side: new BorderSide(color: new HexColor("#005792"))
                    ),
                    color: new HexColor("#2771A3"),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}