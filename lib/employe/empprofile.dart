import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/kritiksaran.dart';
import 'package:hsgfamily/employe/peraturan.dart';
import 'package:hsgfamily/employe/suratperingatan.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

class EmpProfile extends StatefulWidget {

  final String gender, empName, empId, flag;
  final bool edit;

  EmpProfile({this.gender, this.empName, this.empId, this.edit, this.flag});

  _EmpProfile createState() => new _EmpProfile(gender: this.gender, empName: this.empName, empId: this.empId, edit: this.edit, flag: flag);
}

class _EmpProfile extends State<EmpProfile> {

  List dataJson, totalJson;
  String gender, empName, message, empId, msgTotal, bulan, flag;
  TextEditingController textHp = new TextEditingController();
  TextEditingController textEmail = new TextEditingController();
  bool edit;
  var now = new DateTime.now();

  Domain domain = new Domain();
  Info info = new Info();

  _EmpProfile({this.gender, this.empName, this.empId, this.edit, this.flag});

  Future<void> getData() async {
    http.Response hasil = await http.get(
        Uri.encodeFull("http://" +domain.getDomain() +"/loaddata.php?action=getProfile&param=" +empId),
        headers: {"Accept": "application.json"});
    if(this.mounted) {
      this.setState(() {
        dataJson = jsonDecode(hasil.body);
      });

      message = dataJson == null ? '1' : dataJson[0]['emp_id'];

      setState(() {
        textHp.text = flag != empId ? dataJson[0]['hp'] : '******';
        textEmail.text = flag != empId ? dataJson[0]['email'] : '******';
      });
    }
  }

  Future<void> editData(String hp, String email) async {
    http.Response hasil = await http.get(
        Uri.encodeFull("http://" +domain.getDomain() +"/update.php?action=EditProfile&empid=" +empId+"&hp="+hp+"&email="+email),
        headers: {"Accept": "application.json"});

    print(hasil.body);
  }

  Future<String> getTotal(String bulan) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getAbsensiTotal&empid="+empId+"&bulan="+bulan),
        headers:{ "Accept": "application.json" }
    );
    if(this.mounted) {
      this.setState(() {
        totalJson = jsonDecode(hasil.body);
      });

      msgTotal = totalJson == null ? '0' : totalJson[0]['npk'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if(dataJson == null) {
      bulan = info.month(now);

      this.getData();
      this.getTotal(bulan);
    }

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text('Profile',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      ),

      backgroundColor: Colors.white,

      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new Container(
          child: new ListView(
            children: [
              new Container(
                padding: const EdgeInsets.only(top: 0.0),
                child: new Column(
                  children: [
                    new CircleAvatar(
                      backgroundImage: gender == 'M' ? new AssetImage('images/male.png') :
                      gender == 'F' ? new AssetImage('images/female.png'):
                      new AssetImage('images/male.png'),
                      radius: 50,
                    ),

                    new Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: new Text(empName, style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                    ),

                    new Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Icon(Icons.cake, size: 15, ),
                          new Container(
                            margin: const EdgeInsets.only(top: 3,),
                            child: new Text(dataJson == null ? 'Loading...' : dataJson[0]['birthdate'] == null ? ' not set' : ' '+dataJson[0]['birthdate'],
                              style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),

              EmployeInfo(),

              ListData(),
            ],
          ),
        ),
      )
    );
  }

  Widget EmployeInfo() {
    return new Stack(
      children: [
        new Container(
          // color: Colors.red,
            height: 140,
            margin: const EdgeInsets.only(top: 40, left: 0, right: 0),
            child: new Column(
              children: [
                new Container(
                  height: 50,
                  // padding: EdgeInsets.only(left: 40, right: 40),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Container(),

                      new Container(),

                      new Container(
                          child: new Column(
                            children: [
                              new Text(msgTotal == null ? '...' : msgTotal == '0' ? '0' : totalJson[0]['totaltelat'],
                                style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                              new Container(
                                margin: const EdgeInsets.only(top: 5),
                                child:
                                new Text('Total Telat', style: new TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),),
                              )
                            ],
                          )
                      ),

                      new VerticalDivider(
                        thickness: 0.5,
                        width: 10,
                        indent: 7,
                        endIndent: 10,
                      ),

                      new Container(
                          child: new Column(
                            children: [
                              new Text(msgTotal == null ? '...' : msgTotal == '0' ? '0' : totalJson[0]['totalabsen'],
                                style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                              new Container(
                                margin: const EdgeInsets.only(top: 5),
                                child:
                                new Text('Total Absen', style: new TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),),
                              )
                            ],
                          )
                      ),

                      new VerticalDivider(
                        thickness: 0.5,
                        width: 10,
                        indent: 7,
                        endIndent: 10,
                      ),

                      new InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SuratPeringatan(empId: empId, empName: empName,)));
                        },
                        child: new Container(
                            child: new Column(
                              children: [
                                new Text(msgTotal == null ? '...' : msgTotal == '0' ? '0' : totalJson[0]['totalsp'],
                                  style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                new Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child:
                                  new Text('Status SP', style: new TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),),
                                )
                              ],
                            )
                        ),
                      ),

                      new Container(),

                      new Container(),
                    ],
                  ),
                ),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      height: 45,
                      margin: const EdgeInsets.only(top: 25),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey[300]),
                          borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                      child: new FlatButton(
                        onPressed: (){
                          if(Platform.isAndroid) {
                            info.openURL(context, 'http://103.106.78.106:81/hsgfamily/ketentuan.pdf');
                          } else {
                            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Peraturan(title: 'Ketentuan Absen',linkPdf: 'http://103.106.78.106:81/hsgfamily/ketentuan.pdf',)));
                          }
                        },
                        child: new Text('Ketentuan Absen', style: new TextStyle(fontSize: 16),),

                      ),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(left: 10)
                    ),
                    new Container(
                      height: 45,
                      margin: const EdgeInsets.only(top: 25),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.red
                      ),
                      child: new FlatButton(
                        onPressed: (){
                          if(flag != empId) {
                            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new KritikSaran(empId: empId,)));
                          }
                        },
                        child: new Text('Kritik & Keluhan', style: new TextStyle(fontSize: 16, color: Colors.white),),

                      ),
                    ),
                  ],
                )
              ],
            )
        )
      ],
    );
  }

  Widget ListData(){
    return new Container(
      // height: 250,
      child: new ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          new Divider(height: 30,),

          new Container(
            margin: const EdgeInsets.only(left: 17, right: 17),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text('NPK', style: new TextStyle(fontSize: 17),),
                new Text(message == null ? 'Loading...' : empId,
                  style: new TextStyle(color: Colors.grey, fontSize: 17),)
              ],
            ),
          ),

          new Divider(height: 30,),

          new Container(
            margin: const EdgeInsets.only(left: 17, right: 17),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text('Finger Id', style: new TextStyle(fontSize: 17),),
                new Text(dataJson == null ? 'Loading...' : dataJson[0]['emp_finger'] == null ? '' : dataJson[0]['emp_finger'],
                  style: new TextStyle(color: Colors.grey, fontSize: 17),)
              ],
            ),
          ),

          new Divider(height: 30,),

          new Container(
            margin: const EdgeInsets.only(left: 17, right: 17),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text('No Handphone', style: new TextStyle(fontSize: 17),),
                new Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 160,
                  child: new TextField(
                    controller: textHp,
                    textAlign: TextAlign.end,
                    onEditingComplete: (){
                      this.editData(textHp.text, textEmail.text);
                    },
                    enabled: edit,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.only(left: 1.0, bottom: 0.0, top: 0.0),
                      //border: InputBorder.none,
                      hintText: textHp.text,
                      hintStyle: TextStyle(color: Colors.grey,),
                      filled: false,
                    ),
                  ),
                ),
                // new Text(message == null ? 'Loading...' : message != '1' ? dataJson[0]['hp'] : '',
                //   style: new TextStyle(color: Colors.grey, fontSize: 17),)
              ],
            ),
          ),

          new Divider(height: 30,),

          new Container(
            margin: const EdgeInsets.only(left: 17, right: 17),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text('Email', style: new TextStyle(fontSize: 17),),
                new Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 100,
                  child: new TextField(
                    controller: textEmail,
                    textAlign: TextAlign.end,
                    onEditingComplete: (){
                      this.editData(textHp.text, textEmail.text);
                    },
                    enabled: edit,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.only(left: 1.0, bottom: 0.0, top: 0.0),
                      //border: InputBorder.none,
                      hintText: textEmail.text,
                      hintStyle: TextStyle(color: Colors.grey,),
                      filled: false,
                    ),
                  ),
                ),
                // new Text(dataJson == null ? 'Loading...' : dataJson[0]['email'] == null ? '' : dataJson[0]['email'],
                //   style: new TextStyle(color: Colors.grey, fontSize: 17),)
              ],
            ),
          ),

          new Divider(height: 30,),

          new Container(
            margin: const EdgeInsets.only(left: 17, right: 17),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text('Divisi', style: new TextStyle(fontSize: 17),),
                new Text(message == null ? 'Loading...' : dataJson[0]['divisi'],
                  style: new TextStyle(color: Colors.grey, fontSize: 17),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}