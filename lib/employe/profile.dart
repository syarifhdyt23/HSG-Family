import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hsgfamily/employe/empprofile.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';

import 'historyorder.dart';

class Profile extends StatefulWidget {

  Domain domain = new Domain();

  Profile({Key key, this.title, this.empId, this.empName, this.bonCafe, this.gender}) : super(key: key);

  final String title, empId, empName, bonCafe, gender;

  @override
  _Profile createState() => _Profile(domain: domain.getDomain(), empId: empId, empName: empName, bonCafe: bonCafe, gender: gender);

}


class _Profile extends State<Profile> {

  List dataJson;
  String domain, empId, empName, bonCafe, gender;
  Timer timer;
  Size size;
  Info info = new Info();

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  _Profile({this.domain, this.empId, this.empName, this.bonCafe, this.gender});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return new Container(
        width: size.width,
        height: 135,
        margin: const EdgeInsets.only(right: 15, left: 10),
        decoration: new BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(Radius.circular(7)),
            color: Colors.white
        ),
        child: new Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new InkWell(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                  new EmpProfile(gender: gender, empName: empName, empId: empId, edit: true,)));
                },
                child: new ListTile(
                  //contentPadding: const EdgeInsets.only(left: 10),
                    leading: new Icon(Icons.perm_contact_cal_sharp, size: 47,),
                    title: new Text(empId,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    subtitle: new Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: new Text(empName,
                          style: TextStyle(fontSize: 17)),
                    )
                ),
              ),

              new Container(
                height: 0.7,
                width: size.width,
                margin: const EdgeInsets.only(top: 5.0),
                color: Colors.grey[300],
              ),

              new Container(
                alignment: Alignment.center,
                child: new Column(
                    children: [
                      new Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: new InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new HistoryOrders(
                                        empId: empId,
                                        total: bonCafe,
                                        empname: empName,
                                      )));
                            },

                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  margin: const EdgeInsets.only(left: 23),
                                  child: new Text('Bon Cafe', style: new TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w400),),
                                ),

                                new Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: new Row(
                                      children: [
                                        new Text('Rp $bonCafe', style: new TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w400),),
                                        new Padding(padding: EdgeInsets.only(left: 10)),
                                        new Icon(Icons.arrow_forward_ios, size: 17, color: Colors.grey,)
                                      ],
                                    )
                                ),
                              ],
                            ),
                          )
                      )
                    ]
                )
              ),
            ],
          ),
        )
    );
  }

}
