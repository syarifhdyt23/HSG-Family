import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';

class SocialMedia extends StatefulWidget {

  String deviceId;
  Domain domain = new Domain();

  SocialMedia({Key key, this.title, this.deviceId}) : super(key: key);

  final String title;

  @override
  _SocialMedia createState() => _SocialMedia(domain: domain.getDomain(),);

}


class _SocialMedia extends State<SocialMedia> {

  List dataJson;
  String domain, message;
  Timer timer;
  Size size;
  Info info = new Info();

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  _SocialMedia({this.domain});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain+"/loaddata.php?action=getSosMed&param="),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['idpromo'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (Timer T) => this.getData());
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return Container(
      child: new Container(
        //padding: const EdgeInsets.only(bottom: 7),
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
                    info.openApps(context, dataJson[i]['link']);
                  },

                  child: new ShowData(
                    imageLocation: dataJson[i]['image'],
                    barcode: dataJson == null ? '' : dataJson[i]['titlepromo'],
                    itemname: dataJson == null ? '' : dataJson[i]['subtitlepromo'],
                    message: message,
                    createdate: dataJson == null ? '' : dataJson[i]['fromdate'],
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

  final String imageLocation, barcode, itemname, message, createdate;

  ShowData({
    this.imageLocation,
    this.barcode,
    this.itemname,
    this.message,
    this.createdate
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 250,
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 26/13,
                  child: new DecoratedBox(decoration:
                  new BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(image: message == null ? new AssetImage('images/noimage.png') : new NetworkImage(imageLocation), fit: BoxFit.fill)
                  )
                  )
              ),

            ],
          ),

          new Expanded(
              child: new Container(
                width: 250,
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                decoration: new BoxDecoration(
                    //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    new Container(
                      padding: const EdgeInsets.only( right: 10.0, left: 10.0),
                      child: new Text(barcode, style: TextStyle(fontWeight: FontWeight.w500,), maxLines: 1, softWrap: true,
                      ),
                    ),

                    new Container(
                      padding: const EdgeInsets.only( right: 10.0, left: 10.0),
                      child: new Text(itemname, style: TextStyle(color: Colors.grey), maxLines: 1, softWrap: true,
                      ),
                    ),

                    new Container(
                      padding: const EdgeInsets.only( right: 10.0, left: 10.0),
                      child: new Text(createdate, style: TextStyle(color: Colors.grey), maxLines: 1, softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

}
