import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'hexacolor.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Info{

  Size size;
  String version = '1.0.00';
  String kode, empId, empApp, leaveType;
  Domain domain = new Domain();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String getVersion(){
    return version;
  }

  void getComponent(String i, String j, String k){
    this.kode = i;
    this.empId = j;
    this.empApp = k;
  }

  String getLeaveType(){
    return leaveType;
  }

  Future<void> SelectDiv(String empId, String divisi) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/update.php?action=selectDiv&empId=" +empId+"&divisi="+divisi),
        headers: { "Accept": "application.json"}
    );

    jsonDecode(hasil.body);
  }

  Future<void> Approve() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://" + domain.getDomain() + "/update.php?action=Approve&kode="+kode+"&empid="+empId+"&empapp="+empApp),
        headers: { "Accept": "application.json"}
    );

    jsonDecode(hasil.body);
  }

  Future<void> openApps(BuildContext context, String url) async {
    if(await canLaunch(url)) {
      await launch( url, universalLinksOnly: true, forceSafariVC: false, forceWebView: false);
    } else {
      this.MessageInfo(context, 'Message', "Please install this apps");
    }
  }

  Future<void> openURL(BuildContext context, String url) async {
    if(await canLaunch(url)) {
      await launch( url, );
    } else {
      this.MessageInfo(context, 'Message', "Please install this apps");
    }
  }

  String date(DateTime tm) {
    String month;
    switch (tm.month) {
      case 1:
        month = "January ${tm.year}";
        break;
      case 2:
        month = "February ${tm.year}";
        break;
      case 3:
        month = "March ${tm.year}";
        break;
      case 4:
        month = "April ${tm.year}";
        break;
      case 5:
        month = "May ${tm.year}";
        break;
      case 6:
        month = "June ${tm.year}";
        break;
      case 7:
        month = "July ${tm.year}";
        break;
      case 8:
        month = "August ${tm.year}";
        break;
      case 9:
        month = "September ${tm.year}";
        break;
      case 10:
        month = "October ${tm.year}";
        break;
      case 11:
        month = "November ${tm.year}";
        break;
      case 12:
        month = "December ${tm.year}";
        month = "December ${tm.year}";
        break;
    }

    return month;
  }

  String month(DateTime tm) {
    String month;
    switch (tm.month) {
      case 1:
        month = "Januari";
        break;
      case 2:
        month = "Februari";
        break;
      case 3:
        month = "Maret";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "Mei";
        break;
      case 6:
        month = "Juni";
        break;
      case 7:
        month = "Juli";
        break;
      case 8:
        month = "Agustus";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "Oktober";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "Desember";
        break;
    }

    return month;
  }

  void MessageInfo(BuildContext context, String title, String message) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
        ),
        height: 200.0,
        width: 350.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: new HexColor("#005792"),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20,),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: new Text(message, textAlign: TextAlign.center, style: new TextStyle(fontSize: 17),),
            ),

            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                //padding: const EdgeInsets.only(top: 400.0, left: 10.0, right: 10.0,),
                child: new Container(
                    height: 55,
                    width: 350,

                    decoration: BoxDecoration(
                      color: Colors.grey[400].withOpacity(.2),
                      //borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),

                    child: new FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: new Text('Close'),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  void MessageLogOut(BuildContext context, String message, String buttonA, String buttonB) {
    Dialog fancyDialog = Dialog(

      child: Container(
        height: 250.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            new Container(
              child: new Positioned(
                top: 15,
                left: .0,
                right: .0,
                child: Center(
                  child: new CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    backgroundImage: new AssetImage('images/alert.png'),
                  ),
                ),
              ),
            ),

            new Container(
              child: new Positioned(
                top: 130,
                left: .0,
                right: .0,
                child: new Text(message, textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 17, fontFamily: 'helvetica'),),
              ),
            ),

            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                //padding: const EdgeInsets.only(top: 400.0, left: 10.0, right: 10.0,),
                child: new Container(
                    height: 45,
                    width: 350,

                    decoration: BoxDecoration(
                      color: Colors.grey[400].withOpacity(.2),
                      borderRadius: BorderRadius.only(bottomRight: new Radius.circular(15.0)),
                    ),

                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 5,
                          child: new Container(
                            height: 45,
                            child: new FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: new Text(buttonA, style: new TextStyle(fontFamily: 'helvetica', fontWeight: FontWeight.w600),),
                            ),
                          ),
                        ),

                        new Expanded(
                          flex: 5,
                          child: new Container(
                            height: 45,
                            width: 130,
                            padding: const EdgeInsets.only(left: 5.0),
                            child: new FlatButton(
                              onPressed: (){
                                Approve();
                                Navigator.of(context).pop();
                              },
                              child: new Text(buttonB, style: new TextStyle(color: Colors.white, fontFamily: 'helvetica', fontWeight: FontWeight.w600),),
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  void ShowBarcode(BuildContext context, String login, String idcust, String custname){
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return new Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
              ),
              child: login == null ? new Container(
                  alignment: Alignment.center,
                  child: new CircularProgressIndicator (
                    valueColor: AlwaysStoppedAnimation<Color>(new HexColor("#292929")),
                  )
              )
              :
              login == '1' ?
              new ListView(
                children: <Widget>[

                  new Column(
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                        child: new Text('Scan me', textAlign: TextAlign.center, 
                          style: new TextStyle(fontFamily: 'helvetica', fontSize: 17, fontWeight: FontWeight.w600),),
                      ),
                    ],
                  ),

                  new Column(
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, right: 10.0),
                        child: new Text(idcust, textAlign: TextAlign.center, style: new TextStyle(fontFamily: 'helvetica', fontSize: 17, fontWeight: FontWeight.w600),),
                      ),

                      new Container(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, right: 10.0),
                        child: new Text(custname, textAlign: TextAlign.center, style: new TextStyle(fontFamily: 'helvetica', fontSize: 17, fontWeight: FontWeight.w600),),
                      )
                    ],
                  ),
                ],
              )
              :
              new Container(
                alignment: Alignment.center,
                child: new Text('Please login first'),
              )
          );
        }
    );
  }

  void ShowDescriptionItem(BuildContext context, String message, String image, String itemName, String desk){
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return new Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0),
                ),
              ),
              child: message == null ? new Container(
                  alignment: Alignment.center,
                  child: new CircularProgressIndicator (
                    valueColor: AlwaysStoppedAnimation<Color>(new HexColor("#292929")),
                  )
              )
             :
              message != '1' ?
              new Stack(
                children: <Widget>[
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                          child: new InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: new Icon(Icons.close),
                          ),
                        ),

                        new Container(
                          padding: const EdgeInsets.only(top: 20.0, left: 15.0, bottom: 10.0),
                          child: new Text('Description Promo', style: new TextStyle(fontFamily: 'helvetica', fontSize: 18, fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                  ),

                  new Divider(height: 120,),

                  new Container(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: new ListTile(
                      leading: new Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[2],
                            image: new DecorationImage(
                              image: new AssetImage(image),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                      ),
                      title: new Text(itemName),
                      subtitle: new Text('Valid until : dd-MM-yyyy'),
                    ),
                  ),

                  new Divider(height: 295,),

                  new Container(
                    padding: const EdgeInsets.only(top: 140),
                    child: new ListView(
                      children: <Widget>[
                        new Container(
                          padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 10.0),
                          child: new Text(desk, style: new TextStyle(fontFamily: 'helvetica', fontSize: 17,),),
                        )
                      ],
                    ),
                  ),

                  new Align(
                    alignment: Alignment.bottomCenter,
                    child: new Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.90,
                      margin: const EdgeInsets.only(bottom: 20,),
                      child: new FlatButton(
                          onPressed: (){

                          },
                          color: new HexColor("#F07B3F"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(7.0),
                              side: new BorderSide(color: new HexColor("#F07B3F"))
                          ),
                          child: new Text('Use Promo', style: new TextStyle(color: Colors.white, fontFamily: 'helvetica'),)
                      ),
                    ),
                  )
                ],
              )
              :
              new Container(
                alignment: Alignment.center,
                child: new Text('Please login first'),
              )
          );
        }
    );
  }

  void ShowPengiriman(BuildContext context){

    final List<String> pengiriman = ["jne.png", "jnt.png", "tiki.png"];

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return new Container(
              height: MediaQuery.of(context).size.height * 0.50,
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
                          child: new Text('Shipment', style: new TextStyle(fontFamily: 'helvetica', fontSize: 18, fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                  ),

                  new Divider(height: 105,),

                  new Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: new GridView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(5.0),
                      itemCount: 3,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2.5),
                      ),
                      itemBuilder: (context, i){
                        return new Container(
                          margin: const EdgeInsets.all(5),
                          child: new Image(image: new AssetImage('images/'+pengiriman[i])),
                        );
                      },
                    ),
                  )
                ],
              )
          );
        }
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
                            this.SelectDiv(empId, divJson[i]['divname']);
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

  void ShowLeaveType(BuildContext context, String empId){

    final List<String> type = ["Sick", "Annual leave", "Circumcision Of Child", "Deceased Of Family Leave", "Long Leave", "Marriage Leave"];

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
                          child: new Text('Leave Type', style: new TextStyle(fontFamily: 'helvetica', fontSize: 18, fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                  ),

                  new Divider(height: 105,),

                  new Container(
                    padding: const EdgeInsets.only(top: 60),
                    child: new ListView.builder(
                      itemCount: type.length,
                      itemBuilder: (context, i) {
                        return new InkWell(
                          onTap: (){
                            leaveType = type[i];
                            Navigator.of(context).pop();
                          },
                          child: new ListTile(
                            contentPadding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                            title: new Text(type[i]),
                            trailing: new Icon(Icons.arrow_forward_ios, size: 15,),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
          );
        }
    );
  }
}