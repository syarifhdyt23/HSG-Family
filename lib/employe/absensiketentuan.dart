import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/absensi.dart';
import 'package:hsgfamily/employe/peraturan.dart';
import 'package:hsgfamily/employe/suratperingatan.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AbsensiKetentuan extends StatefulWidget {

  final String empId, empName;

  AbsensiKetentuan({this.empId, this.empName});

  _AbsensiKetentuan createState() => new _AbsensiKetentuan(empId: this.empId, empName: this.empName);

}

class _AbsensiKetentuan extends State<AbsensiKetentuan> {

  List totalJson, spJson;
  Size size;
  String bulan, flag, empId, empName, msgTotal, msgSP;

  var now = new DateTime.now();

  Info info = new Info();
  Domain domain = new Domain();

  _AbsensiKetentuan({this.empId, this.empName});

  Future<String> getTotal(String bulan) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getAbsensiTotal&empid="+empId+"&bulan="+bulan),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      totalJson = jsonDecode(hasil.body);
    });

    msgTotal = totalJson == null ? '0' : totalJson[0]['npk'];
  }

  Future<String> getSP() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getSP&empid="+empId),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      spJson = jsonDecode(hasil.body);
    });

    msgSP = spJson == null ? '0' : spJson[0]['npk'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bulan = info.month(now);
    flag = 'sp1';
    this.getTotal(bulan);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    if(totalJson == null) {
      this.getTotal(bulan);
    }

    if(spJson == null) {
      this.getSP();
    }

    return new Container(
      width: size.width,
      height: flag == 'sp1' ? 220 : 170,
      margin: const EdgeInsets.only(right: 15, left: 15),
      decoration: new BoxDecoration(
        //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(Radius.circular(7)),
          color: Colors.white
      ),
      child: new Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5),
        child: new Stack(
          children: <Widget>[
            new InkWell(
              onTap: () {
                if(Platform.isAndroid) {
                  info.openURL(context, 'http://103.106.78.106:81/hsgfamily/ketentuan.pdf');
                } else {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Peraturan(linkPdf: 'http://103.106.78.106:81/hsgfamily/ketentuan.pdf', title: 'Peraturan',)));
                }

              },
              child: new ListTile(
                //contentPadding: const EdgeInsets.only(left: 10),
                leading: new Icon(Icons.settings, size: 47,),
                title: new Text('Peraturan Absensi Karyawan',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                subtitle: new Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: new Text('Berisi ketentuan dan kebijakan yang telah sepakati',
                      style: TextStyle(fontSize: 17)),
                )
              ),
            ),

            new Container(
              height: 0.7,
              width: size.width,
              margin: const EdgeInsets.only(top: 80.0),
              color: Colors.grey[300],
            ),

            new Container(
              margin: const EdgeInsets.only(top: 80),
              child: new InkWell(
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Absensi(empid: empId, empName: empName,)));
                },
                child: new ListTile(
                  //contentPadding: const EdgeInsets.only(left: 10),
                  leading: new Icon(Icons.calendar_today, size: 47,),
                  title: new Text(bulan+', '+now.year.toString(),
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  subtitle: new Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: new Text(totalJson == null ? 'Late : 0, Absen : 0' : 'Late : '+totalJson[0]['totaltelat']+', '+'Absen : '+totalJson[0]['totalabsen'],
                        style: TextStyle(fontSize: 17)),
                  )
                ),
              ),
            ),

            new Container(
              height: 0.7,
              width: size.width,
              margin: const EdgeInsets.only(top: 160.0),
              color: Colors.grey[300],
            ),

            new Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 165),
              child: new InkWell(
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SuratPeringatan(empId: empId, empName: empName,)));
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      margin: const EdgeInsets.only(left: 23),
                      child: new Text(msgSP == null ? 'Loading...' : msgSP == '0' ? 'Clean' : 'Anda mendapakan Surat Peringatan',
                        style: new TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.w400),),
                    ),

                    new Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: new Icon(Icons.arrow_forward_ios, size: 17, color: Colors.grey,)
                    ),
                  ],
                ),

              )
            ),
          ],
        ),
      )
    );
  }
}