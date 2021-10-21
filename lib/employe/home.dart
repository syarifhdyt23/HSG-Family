import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/absensiketentuan.dart';
import 'package:hsgfamily/employe/birthday.dart';
import 'package:hsgfamily/employe/historyorder.dart';
import 'package:hsgfamily/employe/offday.dart';
import 'package:hsgfamily/employe/profile.dart';
import 'package:hsgfamily/employe/requestattendance.dart';
import 'package:hsgfamily/employe/socialmedia.dart';
import 'package:hsgfamily/iconshsg.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flare_flutter/flare_actor.dart';

class Home extends StatefulWidget {
  final String empId;
  Home({this.empId});

  _Home createState() => _Home(empId: empId);
}

class _Home extends State<Home> {
  String empId, message, formattedDate, paramBOD, cekParam;
  Size size;
  List dataJson;
  Timer timer;
  Info info = new Info();
  Domain domain = new Domain();
  var now = new DateTime.now();

  _Home({this.empId});

  Future<void> getData() async {
    http.Response hasil = await http.get(
        Uri.encodeFull("http://" +domain.getDomain() +"/loaddata.php?action=getEmploye&param=" +empId),
        headers: {"Accept": "application.json"});

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['emp_id'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 1), (Timer t) => this.getData());

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    if(dataJson == null) {
      this.getData();
    }

    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: new Text('HSG Family', style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
        ),
        backgroundColor: HexColor("#F2F2F4"),
        body: message == null
            ? new Container(
              color: Colors.white,
              alignment: Alignment.center,
                child: new ColorLoader(),
              )
            : new Stack(
              children: <Widget>[
                new Container(
                  child: new ListView(
                    children: <Widget>[
                      new Container(
                        height: 190,
                        margin: const EdgeInsets.only(
                          top: 5.0,
                        ),
                        child: new Stack(
                          children: <Widget>[
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 17.0, right: 17.0, top: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text("Profile",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            new Container(
                              padding:
                              const EdgeInsets.only(top: 37.0, left: 5.0),
                              child: new Profile(empId: dataJson[0]['emp_id'], empName: dataJson[0]['emp_name'],
                                bonCafe: message == null ? 'Loading...' : message != '1' ? dataJson[0]['kasbon'] : 0, gender: dataJson[0]['getEmploye'],),
                            )
                          ],
                        ),
                      ),

                      new Container(
                        height: 270,
                        child: new Stack(
                          children: <Widget>[
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 17.0, right: 17.0, top: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text("Absensi",
                                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            new Container(
                              padding: const EdgeInsets.only(
                                top: 37.0,
                                bottom: 5.0,
                              ),
                              child: new AbsensiKetentuan(empId: empId, empName: dataJson[0]['emp_name'],)//new SocialMedia(),
                            )
                          ],
                        ),
                      ),

                      new Container(
                        height: 225,
                        margin: const EdgeInsets.only(top: 10.0, bottom: 15),
                        child: new Stack(
                          children: <Widget>[
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 17.0, right: 17.0, top: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        "Birthday",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            new Container(
                              padding:
                                  const EdgeInsets.only(top: 35.0, left: 5.0),
                              child: new Birthday(),
                            )
                          ],
                        ),
                      ),

                      /*new Container(
                        height: 115,
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20),
                        child: new Stack(
                          children: <Widget>[
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 17.0, right: 17.0, top: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        "Announcement",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              padding:
                                  const EdgeInsets.only(top: 35.0, ),
                              child: new OffDay(),
                            )
                          ],
                        ),
                      )*/
                    ],
                  ),
                ),
              ],
            )
    );
  }
}
