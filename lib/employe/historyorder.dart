import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/iconshsg.dart';
import 'package:hsgfamily/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

class HistoryOrders extends StatefulWidget {

  final String empId, total, empname;

  HistoryOrders({this.empId, this.total, this.empname});

  _HistoryOrders createState() => _HistoryOrders(empId: empId, total: total, empname: empname);
}

class _HistoryOrders extends State<HistoryOrders> {

  String empId, message, total, empname;
  List dataJson;
  Size size;
  Domain domain = new Domain();
  DateTime date = DateTime.now();
  final df = new DateFormat('MMMM-yy');

  _HistoryOrders({this.empId, this.total, this.empname});

  Future<void> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/loaddata.php?action=getKasBon&empId=" +empId),
        headers: { "Accept": "application.json"}
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['orderid'];

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: new Text('History Order',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      ),
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Container(
              color: Colors.white,
              height: 70,
              width: size.width,
              child: new Column(
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            child: new Text('Month', style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                          ),
                        ),

                        new Container(
                          child: new Text(df.format(date).toString(), style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                  ),

                  new Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            child: new Text('Total', style: new TextStyle(fontSize: 17, color: new HexColor("#34699a"), fontWeight: FontWeight.w600),),
                          ),
                        ),

                        new Container(
                          child: new Text(total, style: new TextStyle(fontSize: 17, color: new HexColor("#34699a"), fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // new Divider(height: 380, indent: 10, endIndent: 10, color: Colors.grey,),

            new Container(
                margin: const EdgeInsets.only(top: 80),
                child: message == null ? new Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: new ColorLoader(),
                )
                    :
                message != '1' ?
                new Container(
                  color: Colors.white,
                  child: new Scrollbar(
                    child: new ListView.separated(
                      padding: const EdgeInsets.only(top: 5,),
                      itemCount: dataJson == null ? 0 : dataJson.length,
                      itemBuilder: (context, i) {
                        return new ListTile(
                          contentPadding: const EdgeInsets.only(left: 15, right: 15),
                          leading: new Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,

                              child: new Stack(
                                children: <Widget>[
                                  new Align(
                                    alignment: Alignment.topCenter,
                                    child: new Container(
                                        child: new Text(dataJson[i]['Qty'], style: new TextStyle(fontSize: 17, color: Colors.red,  fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                                    ),
                                  ),

                                  new Align(
                                    alignment: Alignment.bottomCenter,
                                    child: new Container(
                                        child: new Text(dataJson[i]['harga'], style: new TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),)
                                    ),
                                  ),
                                ],
                              )
                          ),

                          title: new Stack(
                            children: <Widget>[
                              new Container(
                                // alignment: Alignment.center,
                                child: new Text(dataJson == null ? '' : dataJson[i]['Date']+', '+dataJson[i]['Time'],
                                  style: new TextStyle(color: Colors.grey),
                                ),
                              ),

                              new Container(
                                margin: const EdgeInsets.only(top: 25),
                                child: new Text(dataJson == null ? '' : dataJson[i]['itemmenu'], ),
                              ),
                            ],
                          ),

                          subtitle: new Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: new Stack(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Container(
                                        child: new Text('Disc : '+dataJson[i]['disc'], style: new TextStyle(color: Colors.black),),
                                      ),
                                    ),

                                    new Container(
                                      child: new Text('Net : '+dataJson[i]['net'], style: new TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),

                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider(height: 0.0,);
                      },
                    ),
                  ),
                )
                :
                new Container(
                  alignment: Alignment.center,
                  child: new Text('Not found invoice detail'),
                )
            ),

          ],
        ),
      ),
    );
  }
}