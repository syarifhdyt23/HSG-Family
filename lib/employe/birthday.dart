import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hsgfamily/employe/empprofile.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';

class Birthday extends StatefulWidget {

  Domain domain = new Domain();

  Birthday({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Birthday createState() => _Birthday(domain: domain.getDomain());

}


class _Birthday extends State<Birthday> {

  List dataJson;
  String domain, message, monthYear;
  Timer timer;
  Size size;
  Info info = new Info();

  var now = new DateTime.now();
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  _Birthday({this.domain});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain+"/loaddata.php?action=getBirthdate"),
        headers:{ "Accept": "application.json" }
    );
    if(this.mounted) {
      this.setState(() {
        dataJson = jsonDecode(hasil.body);
      });

      message = dataJson == null ? '1' : dataJson[0]['emp_id'];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => this.getData());
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return //message == null || message == '1' ?
      new Container(
        width: size.width,
        height: 190,
        margin: const EdgeInsets.only(right: 15, left: 7),
        decoration: new BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(Radius.circular(7)),
            color: Colors.white
        ),
        child: new Stack(
          children: <Widget>[
            new ListTile(
              //contentPadding: const EdgeInsets.only(left: 10),
              leading: new Container(
                height: 40,
                child: new Stack(
                  children: [
                    new Image(image: AssetImage('images/birthday.gif'),),
                  ]
                )
              ),
              title: new Text(info.date(now),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              subtitle: new Container(
                margin: const EdgeInsets.only(top: 5),
                child: new Text(message == null ? 'Loading...' : message != '1' ? 'Employe birthday in this month' : 'No birthday in this month',
                    style: TextStyle(fontSize: 17)),
              )
            ),
            new Container(
              height: 0.7,
              width: size.width,
              margin: const EdgeInsets.only(top: 70.0),
              color: Colors.grey[300],
            ),

            new Container(
              child: new Scrollbar(
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                    scrollDirection: Axis.horizontal,
                    itemCount: dataJson == null ? 0 : dataJson.length,
                    itemBuilder: (context, i) {
                      return new Container(
                        padding: const EdgeInsets.only(top: 80),
                        margin: const EdgeInsets.only(left: 7, right: 8),
                        child: new Container(
                          height: 60,
                          width: 80,
                          child: new InkWell(
                            onTap: (){
                              Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                              new EmpProfile(gender: dataJson[i]['pict'], empName: dataJson[i]['emp_name'], empId: dataJson[i]['emp_id'], edit: false)));
                            },
                            child: new Column(
                              children: [
                                new AspectRatio(
                                  aspectRatio: 7.0 / 7.0,
                                  child: new CircleAvatar(
                                    backgroundImage: dataJson[i]['pict'] == 'M' ? new AssetImage('images/male.png') :
                                    dataJson[i]['pict'] == 'F' ? new AssetImage('images/female.png'):
                                    new AssetImage('images/male.png'),
                                    radius: 100,
                                  ),
                                ),
                                new Text(dataJson[i]['emp_name'].toString().substring(0, 8)+'...')
                              ],
                            ),
                          ),
                        )
                      );
                    }
                ),
              ),
            )
          ],
        ),
      );
      /*:
    new Container(
      child: new Container(
        //padding: const EdgeInsets.only(bottom: 7),
        child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataJson == null ? 0 : dataJson.length,
            itemBuilder: (context, i) {
              return new InkWell(
                splashColor: Colors.white.withOpacity(.2),
                highlightColor: Colors.white.withOpacity(.2),
                onTap: (){
                  //Navigator.push(context, new MaterialPageRoute(builder: (context) => new ArticleDetail(articleId: dataJson[i]['articleid'], articleName: dataJson[i]['articlename'],)));
                },

                child: new ShowData(
                  empname: dataJson == null ? '' : dataJson[i]['emp_name'],
                  empdob: dataJson == null ? '' : dataJson[i]['birthdate'],
                  message: message,
                ),

              );
            }
        ),
      ),

    );*/
  }
}

class ShowData extends StatelessWidget {

  final String empname, empdob, message;

  ShowData({
    this.empname,
    this.empdob,
    this.message
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 300,
      padding: const EdgeInsets.only(right: 7, left: 7),
      /*decoration: new BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(Radius.circular(15)),
          color: Colors.white
      ),*/
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 22/14,
                  child: new DecoratedBox(decoration:
                  new BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(10)),
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(image: new AssetImage('images/birthday.png'), fit: BoxFit.cover)
                  )
                  )
              ),

              new Container(
                margin: const EdgeInsets.only(top: 10, right: 20),
                alignment: Alignment.topRight,
                child: new Text(empname, style: new TextStyle(fontWeight: FontWeight.bold),),
              ),

              new Container(
                margin: const EdgeInsets.only(top: 30, right: 20),
                alignment: Alignment.topRight,
                child: new Text(empdob, style: new TextStyle(fontWeight: FontWeight.bold),),
              ),

              new Container(
                height: 27,
                margin: const EdgeInsets.only(top: 135, right: 20),
                alignment: Alignment.bottomRight,
                child: new FlatButton(
                    onPressed: (){},
                    child: new Text('Said Congrats', style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                )
              ),
            ],
          ),


        ],
      ),
    );
  }

}

class EmptyData extends StatelessWidget {

  final String empname, empdob, message;

  EmptyData({
    this.empname,
    this.empdob,
    this.message
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      width: 300,
      margin: const EdgeInsets.only(right: 7, left: 7),
      decoration: new BoxDecoration(
        //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(Radius.circular(15)),
          color: Colors.white
      ),
      child: new ListTile(
        //contentPadding: const EdgeInsets.only(left: 10),
        leading: new Icon(Icons.calendar_today, size: 47,),
        title: new Text('Title'),
        subtitle: new Text('Subtitle'),
      ),
    );
  }

}
