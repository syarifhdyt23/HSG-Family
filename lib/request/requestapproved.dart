import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/info.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';

class RequestApproved extends StatefulWidget {

  final String empId, empname, kode, empApp, cekId;

  RequestApproved({this.empId, this.empname, this.kode, this.empApp, this.cekId});

  _RequestApproved createState() => _RequestApproved(empId: empId, empname: empname, kode: kode, empApp: empApp, cekId: cekId);
}

class _RequestApproved extends State<RequestApproved> {

  List dataJson;
  String empId, startDate, toDate, flagDate, index, empname, flag, message, kode, empApp, cekId;
  Size size;
  Info info = new Info();
  Domain domain = new Domain();

  TextEditingController textReason = new TextEditingController();

  _RequestApproved({this.empId, this.empname, this.kode, this.empApp, this.cekId});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getViewRequestEmp&empid="+empId+"&param="+kode),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['empid'];

    textReason.text = dataJson[0]['reason'];
  }

  Future<void> ShowDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate: DateTime.now().subtract( Duration(days: 30)),
        lastDate:  DateTime.now().add( Duration(days: 30)),
        builder: (context, child) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: new Container(
                  height: 550,
                  width: 550,
                  child: child,
                ),
              )
            ],
          );
        }
    );

    if(d != null) {
      setState(() {
        flagDate == 'Start' ? startDate = new DateFormat('yyyy-MM-dd').format(d) : toDate = new DateFormat('yyyy-MM-dd').format(d);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDate = 'yyyy-MM-dd';
    toDate = 'yyyy-MM-dd';

    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 1.1,
        title: new Text('Form Approval'),
      ),
      backgroundColor: Colors.white,
      body: message == null ? new Container(
        child: new FlareActor('images/loading.flr',
          alignment: Alignment.center, fit: BoxFit.contain, animation: 'loading', ),
      )
      :
      new Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 1, ),
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 40,
                width: size.width,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: dataJson[0]['status'] == '1' ? Colors.yellow.withOpacity(.2) : dataJson[0]['status'] == '2' ? Colors.green.withOpacity(.2) : Colors.red.withOpacity(.2)
                ),
                child: new Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: new Row(
                    children: [
                      new Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: dataJson[0]['status'] == '1' ? new Icon(Icons.warning, color: Colors.orange,) :
                        dataJson[0]['status'] == '2' ? new Icon(Icons.check, color: Colors.green,) :
                        new Icon(Icons.close, color: Colors.red,),
                      ),

                      new Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: new Text(dataJson[0]['status'] == '1' ? 'Pending' : dataJson[0]['status'] == '2' ? 'Approve by '+dataJson[0]['empapprove'] : 'Reject'),
                      )
                    ],

                  ),
                ),
              ),

              new Container(
                margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Start Date', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

              new Container(
                width: size.width,
                height: 45,
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new FlatButton(
                  onPressed: (){},
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(dataJson[0]['fromdate'], style: new TextStyle(fontWeight: FontWeight.w400),),
                  ),
                  color: Colors.grey.withOpacity(.2),
                ),
              ),

              new Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('End Date', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

              new Container(
                width: size.width,
                height: 45,
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new FlatButton(
                  onPressed: (){},
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(dataJson[0]['todate'], style: new TextStyle(fontWeight: FontWeight.w400),),
                  ),
                  color: Colors.grey.withOpacity(.2),
                ),
              ),

              new Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Leave Type', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

              new Container(
                width: size.width,
                height: 45,
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new FlatButton(
                  onPressed: (){},
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(dataJson[0]['leavetype'], style: new TextStyle(fontWeight: FontWeight.w400),),
                  ),
                  color: Colors.grey.withOpacity(.2),
                ),
              ),

              new Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Reason', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

              new Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new TextField (
                  controller: textReason,
                  maxLines: 5,

                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.0), width: 1.0),
                    ),
                    contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 7.0),
                    //border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                    labelStyle: TextStyle(color: Colors.black, ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  style: new TextStyle(fontWeight: FontWeight.w400),
                  textInputAction: TextInputAction.next,
                  readOnly: true,

                ),
              ),

              dataJson[0]['status'] == '3' ? new Container()
                  :
              dataJson[0]['empid'] == cekId ? new Container()
                  :
              dataJson[0]['level'] == '0' || dataJson[0]['level'] == '1' ?
              new Container(
                width: size.width,
                height: 40,
                margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: new FlatButton(
                  onPressed: (){
                    info.getComponent(kode, empId, empApp);
                    info.MessageLogOut(context, 'Are you sure want to approved', 'No', 'Yes');
                  },
                  child: new Text('Approve', style: new TextStyle(color: Colors.white),),
                  color: Colors.blue,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
              )
                  :
              new Container(),

              dataJson[0]['status'] == '3' ? new Container()
                  :
              dataJson[0]['empid'] == cekId ? new Container(
              )
                  :
              dataJson[0]['level'] == '0' || dataJson[0]['level'] == '1' ?
              new Container(
                width: size.width,
                height: 40,
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new FlatButton(
                  onPressed: (){
                    info.getComponent(kode, empId, empApp);
                    info.MessageLogOut(context, 'Are you sure want to reject', 'No', 'Yes');
                  },
                  child: new Text('Reject', style: new TextStyle(color: Colors.white),),
                  color: Colors.red,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
              )
                  :
              new Container()
            ],
          ),
        ),
      ),
    );
  }
}