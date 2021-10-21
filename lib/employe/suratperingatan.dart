import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/peraturan.dart';
import 'package:hsgfamily/employe/suratsp.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/loading.dart';
import 'package:hsgfamily/login/loadinglogin.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SuratPeringatan extends StatefulWidget {

  final String empId, empName;

  SuratPeringatan({this.empId, this.empName});

  _SuratPeringatan createState() => new _SuratPeringatan(empId: this.empId, empName: this.empName);
}

class _SuratPeringatan extends State<SuratPeringatan> {

  Size size;
  String empId, empName, message;
  List dataJson;
  Domain domain = new Domain();
  Info info = new Info();

  String messageSP1 = 'http://103.106.78.106:81/hsgfamily/sp1.pdf';
  String messageSP2 = 'http://103.106.78.106:81/hsgfamily/sp2.pdf';

  _SuratPeringatan({this.empId, this.empName});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getSP&empid="+empId),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['npk'];
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
        title: new Text('Surat Peringatan',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      ),

      body: message == null ? new Container(
        child: new Align(
          alignment: Alignment.center,
          child: new ColorLoader()
        ),
      )
      :
      message != '1' ?
      new Stack(
        children: [
          new Container(
            margin: const EdgeInsets.only(top: 15, left: 15, right: 10),
            child: new Text(empName, style: new TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 19),),
          ),

          new Container(
            height: dataJson.length == 1 ? 85 : 165,
            margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: new ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataJson == null ? 0 : dataJson.length,
              itemBuilder: (context, i) {
                return new Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: new ListTile(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                        new SP(nama: empName,numberSP: dataJson[i]['keterangan'],jabatan: dataJson[i]['lvl'],tgl: dataJson[i]['tanggal'],)
                        // new Peraturan(linkPdf: dataJson[i]['keterangan'] == 'Surat Peringatan 1' ? messageSP1 : messageSP2, title: dataJson[i]['keterangan'])
                      ));
                      // if(Platform.isAndroid) {
                      //   if(dataJson[i]['keterangan'] == 'Surat Peringatan 1') {
                      //     info.openURL(context, messageSP1);
                      //   }else if(dataJson[i]['keterangan'] == 'Surat Peringatan 2') {
                      //     info.openURL(context, messageSP1);
                      //   }
                      // } else {
                      //   Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                      //       new SP()
                      //   // new Peraturan(linkPdf: dataJson[i]['keterangan'] == 'Surat Peringatan 1' ? messageSP1 : messageSP2, title: dataJson[i]['keterangan'])
                      //   ));
                      // }
                    },
                    title: new Text(dataJson[i]['keterangan'], style: new TextStyle(color: Colors.blue, fontSize: 17),),
                    subtitle: new Text('keluar tanggal : '+dataJson[i]['tanggal']+", jam : "+dataJson[i]['waktu']),
                    trailing: new Icon(dataJson[i]['status'] == 'Actived' ? Icons.check : null, size: 17, color: Colors.green, ),
                  ),
                );
              },
            ),
          )
        ],
      )
      :
      new Container(
        alignment: Alignment.center,
        child: new Text(
          'Tidak ada surat peringatan yang di keluarkan untuk anda',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 19),
        ),
      ),
    );
  }
}