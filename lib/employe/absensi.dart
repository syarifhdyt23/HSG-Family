import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/peraturan.dart';
import 'package:hsgfamily/employe/suratperingatan.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Absensi extends StatefulWidget {

  final String empid, empName;

  Absensi({this.empid, this.empName});

  _Absensi createState() => _Absensi(empid: empid, empName: empName);
}

class _Absensi extends State< Absensi> {

  Size size;
  String message, empid, bulan, msgTotal, empName;
  List dataJson, monthJson, totalJson;

  var now = new DateTime.now();

  Info info = new Info();
  Domain domain = new Domain();

  TextEditingController textEmpId = new TextEditingController();

  _Absensi({this.empid, this.empName});

  Future<String> getData(String bulan) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getAbsensi&empid="+empid+"&bulan="+bulan),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['npk'];
  }

  Future<String> getTotal(String bulan) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getAbsensiTotal&empid="+empid+"&bulan="+bulan),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      totalJson = jsonDecode(hasil.body);
    });

    msgTotal = totalJson == null ? '0' : totalJson[0]['npk'];
  }

  Future<String> getBulan() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getMonth"),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      monthJson = jsonDecode(hasil.body);

      this.getData(info.month(now));
      this.getTotal(info.month(now));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bulan = info.month(now);
    this.getData(info.month(now));
    this.getBulan();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Column(
          children: [
            new Text('Absensi', style: new TextStyle(fontWeight: FontWeight.w600),),
            new Container(
              margin: const EdgeInsets.only(top: 5),
              child: new Text(bulan+', '+now.year.toString(), style: new TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),),
            )
          ],
        ),
        actions: [
          new IconButton(
              icon: new Icon(Icons.filter_list_outlined),
              onPressed: (){
                setState(() {
                  //bulan = info.month(now);
                  //this.getData(info.month(now));
                  this.ShowMonth(context);
                });
              }
          ),
        ],
      ),

      backgroundColor: Colors.white,

      body: new Container(
        //margin: const EdgeInsets.only(top: 5),
        child: new Stack(
          children: [
            new Container(
              // color: Colors.red,
              height: 180,
              margin: const EdgeInsets.only(top: 40, left: 0, right: 0),
              child: new Column(
                children: [
                  new Container(
                    height: 50,
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
                          onTap: (){
                            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SuratPeringatan(empName: empName, empId: empid,)));
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
                            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Peraturan()));
                          }
                        },
                        child: new Text('Ketentuan Absen', style: new TextStyle(fontSize: 16),),

                    ),
                  ),
                  
                  new Divider(
                    thickness: 0.5,
                    height: 60,
                  ),

                ],
              )
            ),

            message == null ? new Container(
              margin: const EdgeInsets.only(top: 100),
              color: Colors.white,
              alignment: Alignment.center,
              child: new ColorLoader(),
            )
            :
            message == '1' ? new Container(
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: new Text('No data absen in server', style: new TextStyle(fontSize: 20, fontWeight: FontWeight.w300),),
            )
            :
            new Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 185, bottom: 15),
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: new DataTable(
                  columnSpacing: 25,

                  columns: const <DataColumn> [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Time In')),
                    DataColumn(label: Text('Time Out')),
                    DataColumn(label: Text('Late'), ),
                  ],

                  rows: dataJson.map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["tanggal"], style: new TextStyle(color: int.parse(element["telat"]) > 0 ? Colors.red : Colors.black))),
                        DataCell(Text(element["time_in"], style: new TextStyle(color: int.parse(element["telat"]) > 0 ? Colors.red : Colors.black))),
                        DataCell(Text(element["time_out"], style: new TextStyle(color: int.parse(element["telat"]) > 0 ? Colors.red : Colors.black))),
                        DataCell(
                            new Align(
                              alignment: Alignment.center,
                              child: new Text(element["telat"], style: new TextStyle(color: int.parse(element["telat"]) > 0 ? Colors.red : Colors.black),),
                            )
                        ),
                      ],
                    )),
                  ).toList(),
                ),
              )
            )
          ],
        )
      ),
    );
  }

  void ShowMonth(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return new Container(
            // height: 500,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: new Text('Month', style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 17),),
                ),

                new Container(
                  height: 350,
                  margin: const EdgeInsets.only(top: 10),
                  child: new ListView.builder(
                    itemCount: monthJson.length,
                    itemBuilder: (context, i) {
                      return new InkWell(
                        onTap: (){
                          setState(() {
                            message = null;
                            bulan = monthJson[i]['nama_bulan'];
                            this.getData(bulan);
                            this.getTotal(bulan);
                            Navigator.of(context).pop();
                          });
                        },
                        child: new Container(
                          child: new ListTile(
                              title: new Align(
                                alignment: Alignment.center,
                                child: new Text(monthJson[i]['nama_bulan'], style: new TextStyle(fontSize: 20),),
                              )
                          ),
                        ),
                      );
                    },
                  )
                )
              ],
            ),
          );
        }
    );
  }
}