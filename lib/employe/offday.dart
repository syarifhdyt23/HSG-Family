import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';

class OffDay extends StatefulWidget {

  Domain domain = new Domain();

  OffDay({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OffDay createState() => _OffDay(domain: domain.getDomain());

}


class _OffDay extends State<OffDay> {

  List dataJson;
  String domain, message;
  Timer timer;
  Size size;
  var now = DateTime.now();
  Info info = new Info();

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  _OffDay({this.domain});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain+"/loaddata.php?action=getBirthdate"),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['emp_id'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getData();
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return message == null || message == '1' ?
      new Container(
        width: size.width,
        margin: const EdgeInsets.only(right: 10, left: 15),
        decoration: new BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(Radius.circular(7)),
            color: Colors.white
        ),
        child: new ListTile(
          //contentPadding: const EdgeInsets.only(left: 10),
          leading: new Icon(Icons.calendar_today, size: 47,),
          title: new Text(info.date(now)),
          subtitle: new Text('No off day at this moment'),
        ),
      )
      :
      new Container(
        margin: const EdgeInsets.only(left: 10),
        child: new Container(
          child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataJson == null ? 0 : dataJson.length,
              itemBuilder: (context, i) {
                if(message == null) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(new HexColor("#2d4059"))),);
                } else {
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
              }
          ),
        ),
      );
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
    return new Container(
      width: 300,
      margin: const EdgeInsets.only(right: 7, left: 7),
      decoration: new BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(Radius.circular(7)),
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
