import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/info.dart';
import 'package:intl/intl.dart';

class RequestAttendance extends StatefulWidget {

  final String empname;

  RequestAttendance({this.empname});

  _RequestAttendance createState() => _RequestAttendance(empname: empname);
}

class _RequestAttendance extends State<RequestAttendance> {

  String empId, startDate, toDate, flagDate, index, empname, flag;
  Size size;
  Info info = new Info();

  TextEditingController textStartDate = new TextEditingController();

  _RequestAttendance({this.empId, this.empname});

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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 1.1,
        centerTitle: true,
        title: new Text('Form Request Attendance',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      ),
      backgroundColor: Colors.white,
      body: new ListView(
        children: [
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: new Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 10, ),
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
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
                        onPressed: (){
                          flagDate = 'Start';
                          this.ShowDate(context);
                        },
                        child: new Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(startDate, style: new TextStyle(fontWeight: FontWeight.w400, color: startDate == 'yyyy-MM-dd' ? Colors.grey : Colors.black),),
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
                        onPressed: (){
                          flagDate = 'End';
                          this.ShowDate(context);
                        },
                        child: new Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(toDate, style: new TextStyle(fontWeight: FontWeight.w400, color: toDate == 'yyyy-MM-dd' ? Colors.grey : Colors.black),),
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
                        onPressed: (){
                          info.ShowLeaveType(context, empId);
                        },
                        child: new Align(
                          alignment: Alignment.centerLeft,
                          child: new Text('Select', style: new TextStyle(color: Colors.grey),),
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
                        controller: textStartDate,
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
                          hintText: "yyyy-mm-dd",
                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                          labelStyle: TextStyle(color: Colors.black, ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),

                        textInputAction: TextInputAction.next,
                      ),
                    ),

                    new Container(
                      width: size.width,
                      height: 45,
                      margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: new FlatButton(
                        onPressed: (){
                        },
                        child: new Text('Submit', style: new TextStyle(color: Colors.white, fontSize: 17),),
                        color: new HexColor("#2771A3"),
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}