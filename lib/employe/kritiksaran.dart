import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

class KritikSaran extends StatefulWidget {

  final String empId;

  KritikSaran({this.empId});

  @override
  _KritikSaranState createState() => _KritikSaranState(empId: empId);
}

class _KritikSaranState extends State<KritikSaran> {

  List<String> type = ['Kritik', 'Saran', 'Keluhan'];
  String selecttype = 'Select Type';
  String empId;

  TextEditingController textKritik = new TextEditingController();

  Info info = new Info();
  Domain domain = new Domain();

  _KritikSaranState({this.empId});

  Future<void> addKritikSaran(String tipe, String remark) async {
    http.Response hasil = await http.get(
        Uri.encodeFull("http://" +domain.getDomain() +"/insert.php?action=addKritikSaran&empId=" +empId+"&tipe="+tipe+"&remark="+remark),
        headers: {"Accept": "application.json"});

    print(hasil.body);
  }

  void ShowToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Kritik & Saran',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
        centerTitle: true,
        elevation: 0,
      ),

      backgroundColor: Colors.white,

      body: new ListView(
        children: [
          // Rectangle 6
          Container(
              height: 277,
              decoration: BoxDecoration(
                  color: const Color(0xffffffff)
              ),
            child: Image(
              image: AssetImage('images/feedback.png'),
            ),
          ),
          // Rectangle 4
          // Rectangle 7
          Container(
              height: 45,
              padding: EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xfff0f0f0),
                    width: 1
                ),
                color: const Color(0xffffffff)
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Container(
                  child: new Text('Select type', style: TextStyle(fontWeight: FontWeight.w600),)
                ),
                new Row(
                  children: [
                    DropdownButton<String>(
                      items: type.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      hint: Text(selecttype),
                      onChanged: (newVal) {
                        setState(() {
                          selecttype = newVal;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          // Rectangle 4
          new Container(
              height: 192,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xfff0f0f0),
                      width: 1
                  ),
                  color: const Color(0xffffffff)
              ),
              padding: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: TextField(
              maxLines: 8,
              controller: textKritik,
              decoration: InputDecoration.collapsed(
                  hintText: "Silahkan tulis disini"
              ),
            ),
          ),

          new Container(
            margin: const EdgeInsets.only(left: 15, top: 5),
            child: new Text('Identitas anda akan menjadi anonymous', style: new TextStyle(color: Colors.grey,), ),
          ),
          new Container(
            height: 45,
            margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.blue
            ),
            child: new FlatButton(
              onPressed: (){
                if(selecttype == 'Select Type') {
                  info.MessageInfo(context, 'Message', 'Silahkan pilih type');
                }else if(textKritik.text == "") {
                  info.MessageInfo(context, 'Message', 'Silahkan tulis di inputan yang tersedia');
                }else{
                  this.addKritikSaran(selecttype, textKritik.text);
                  Navigator.of(context).pop();
                  this.ShowToast('Kritik & Keluhan terkirim');
                }
              },
              child: new Text('Send', style: new TextStyle(fontSize: 16, color: Colors.white),),

            ),
          )
        ],
      )
    );
  }
}
