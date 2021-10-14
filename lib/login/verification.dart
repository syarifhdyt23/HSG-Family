import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/home.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/login/login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:hsgfamily/run.dart';
import 'package:intl/intl.dart';

class Verification extends StatefulWidget {

  final String empId;

  Verification({this.empId});

  _Verification createState() => _Verification(empId: empId);
}

class _Verification extends State<Verification> {

  String message, empId, identifier, deviceId, divisi;
  Size size;
  List dataJson, divJson;
  Timer timer;
  Info info = new Info();
  Domain domain = new Domain();

  _Verification({this.empId});

  TextEditingController textPhoneNumb = new TextEditingController();
  TextEditingController textEmail = new TextEditingController();
  TextEditingController textAbsenId = new TextEditingController();


  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<void> getData() async {

    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      identifier = androidInfo.androidId.toString();
      deviceId = "android";
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      identifier = iosInfo.identifierForVendor.toString();
      deviceId = "ios";
    }

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/loaddata.php?action=getEmploye&param=" +empId),
        headers: { "Accept": "application.json"}
    );
    if(this.mounted) {
      this.setState(() {
        dataJson = jsonDecode(hasil.body);
      });

      message = dataJson == null ? '1' : dataJson[0]['emp_id'];

      textPhoneNumb.text = dataJson == null ? '' : dataJson[0]['hp'];
      textEmail.text = dataJson == null ? '' : dataJson[0]['email'];
      divisi = dataJson == null ? '' : dataJson[0]['divisi'];
    }
  }

  Future<void> SaveData() async {

    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      identifier = androidInfo.androidId.toString();
      deviceId = "android";
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      identifier = iosInfo.identifierForVendor.toString();
      deviceId = "ios";
    }

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/update.php?action=saveData&empId="+dataJson[0]['emp_id']+"&email="+textEmail.text+"&hp="+textPhoneNumb.text+"&absen="+textAbsenId.text+"&identifier="+identifier+"&div="+divisi),
        headers: { "Accept": "application.json"}
    );

    jsonDecode(hasil.body);
  }

  Future<void> getDivisi() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getDivisi"),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      divJson = jsonDecode(hasil.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getData();
    this.getDivisi();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      body: message == null ? new Container(
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
      message == '1' ? new Container(
        alignment: Alignment.center,
       margin: const EdgeInsets.only(top: 10),
       child: new ListView(

         children: [
           new Container(
             alignment: Alignment.topCenter,
             margin: const EdgeInsets.only(top: 10,),
             child: new Text('Verification Data', style: new TextStyle(fontSize: 25),),
           ),

           new Container(
             alignment: Alignment.topCenter,
             margin: const EdgeInsets.only(top: 150,),
             child: new Text('$empId', style: new TextStyle(fontSize: 25),),
           ),

           new Container(
             alignment: Alignment.topCenter,
             margin: const EdgeInsets.only(top: 5,),
             child: new Text('not register to server', style: new TextStyle(fontSize: 25),),
           ),

           new Container(
             margin: const EdgeInsets.only(top: 20, right: 25.0, bottom: 30, left: 20),
             child: new FlatButton(
                 onPressed: (){
                   Navigator.of(context).pop();
                 },
                 color: new HexColor("#005792"),
                 shape: new RoundedRectangleBorder(
                     borderRadius: new BorderRadius.circular(3.0),
                     side: new BorderSide(color: new HexColor("#005792"))
                 ),
                 child: new Text('Login', style: new TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'helvetica'),)
             )
           )
         ],
       )
      )
      :
      dataJson[0]['verified'] == '0' ?
      new Container(
        child: new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: new ListView(
            children: <Widget>[
              new Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 10,),
                child: new Text('Verification Data', style: new TextStyle(fontSize: 25),),
              ),

              new Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 15),
                child: new Stack(
                  children: <Widget>[
                    new Image.asset('images/frameid.png'),
                    new Positioned(
                      left: .0,
                      right: .0,
                      child: new Image.asset(dataJson[0]['gender'] == 'M' ? 'images/male.png' : 'images/female.png'),
                    ),

                    new Positioned(
                        left: size.width / 5,
                        right: .0,
                        bottom: 40,
                        child: new Text(dataJson[0]['emp_id'], style: new TextStyle(fontWeight: FontWeight.w600),)
                    ),

                    new Positioned(
                        left: .0,
                        right: .0,
                        bottom: 20,
                        child: new Align(
                          alignment: Alignment.center,
                          child: new Text(dataJson[0]['emp_name'], style: new TextStyle(fontWeight: FontWeight.w600),),
                        )
                    ),
                  ],
                ),
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 10),
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new TextField (
                    controller: textPhoneNumb,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.0), width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 7.0),
                      //border: InputBorder.none,
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                      labelStyle: TextStyle(color: Colors.black, ),
                      suffixIcon: new Icon(Icons.phone_android, color: new HexColor("#005792"),),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),

                    keyboardType: TextInputType.number,
                  ),
                ),
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 10),
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new TextField (
                    controller: textEmail,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.0), width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 7.0),
                      //border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                      labelStyle: TextStyle(color: Colors.black, ),
                      suffixIcon: new Icon(Icons.label, color: new HexColor("#005792"),),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),

                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 10),
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new FlatButton(
                      onPressed: (){
                        ShowDivisi(context, empId, divJson);
                      },

                      color: Colors.grey.withOpacity(.2),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(dataJson == null ? 'Select Divisi' : divisi,
                              style: new TextStyle(color: divisi == null ? Colors.grey : Colors.black, fontFamily: 'helvetica')),
                          new Icon(Icons.arrow_forward_ios, size: 17, color: new HexColor("#005792"),)
                        ],
                      )
                  ),
                ),
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 10),
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new TextField (
                    controller: textAbsenId,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.0), width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 7.0),
                      //border: InputBorder.none,
                      hintText: "Absen Id",
                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                      labelStyle: TextStyle(color: Colors.black, ),
                      suffixIcon: new Icon(Icons.person_pin_outlined, color: new HexColor("#005792"),),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),

                    keyboardType: TextInputType.number,
                  ),
                ),
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 15),
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new FlatButton(
                      onPressed: (){
                        setState(() {
                          if(textPhoneNumb.text == "") {
                            info.MessageInfo(context, 'Message', 'Phone Number must be field in');
                          }else if(textEmail.text == "") {
                            info.MessageInfo(context, 'Message', 'Email must be field in');
                          }else if(textAbsenId.text == "") {
                            info.MessageInfo(context, 'Message', 'Absen id must be field in');
                          }else {
                            this.SaveData();
                            this.getData();
                          }
                        });
                      },
                      color: new HexColor("#005792"),
                      child: new Text('Save', style: new TextStyle(color: Colors.white, fontFamily: 'helvetica', fontSize: 17),)
                  ),
                ),
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 7),
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      color: Colors.red,
                      child: new Text('Close', style: new TextStyle(color: Colors.white, fontFamily: 'helvetica', fontSize: 17),)
                  ),
                ),
              ),
            ],
          ),
        ),
      )
      :
      new Run(empId: dataJson[0]['emp_id'], empname: dataJson[0]['emp_name'],)
    );
  }

  void ShowDivisi(BuildContext context, String empId, List divJson){
    // final List<String> divisi = divJson;

    // final List<String> divisi = ["Cafe", "H23", "Hansprint", "Helihantoys", "HSG", "HSG IT", "HSG Media", "HSG Moto", "H23", "HSG Tools", "IJ", "Vapehan", "VLI"];

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return new Container(
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: new Stack(
                children: <Widget>[
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                          child: new InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: new Icon(Icons.close),
                          ),
                        ),

                        new Container(
                          padding: const EdgeInsets.only(top: 20.0, left: 15.0, bottom: 10.0),
                          child: new Text('Divisi', style: new TextStyle(fontFamily: 'helvetica', fontSize: 18, fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                  ),

                  new Divider(height: 105,),

                  new Container(
                    padding: const EdgeInsets.only(top: 60),
                    child: new ListView.separated(
                      itemCount: divJson.length,
                      itemBuilder: (context, i) {
                        return new InkWell(
                          onTap: (){
                            setState(() {
                              divisi = divJson[i]['divname'];
                            });
                            // this.SelectDiv(empId, divJson[i]['divname']);
                            Navigator.of(context).pop();
                          },
                          child: new Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: new Text(
                                divJson[i]['divname']
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[400],
                      ),
                    ),
                  )
                ],
              )
          );
        }
    );
  }
}