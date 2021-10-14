import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ListBOD extends StatefulWidget {

  _ListBOD createState() => _ListBOD();
}

class _ListBOD extends State<ListBOD> {

  String message;
  List dataJson;
  int itemNumb = 10;
  Size size;


  Info info = new Info();
  Domain domain = new Domain();

  Future<String> getData(String limit) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getBirthdate"),
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

    this.getData(itemNumb.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: new HexColor("#2771A3"),
          title: new Text('Birthday'),
        ),

        backgroundColor: Colors.grey[200],
        body: new Container(
          child: message == null ?
          new ColorLoader()
              :
          message != "1" ?
          NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if(scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                  setState(() {
                    itemNumb += 10;

                    this.getData(itemNumb.toString());
                  });
                }
              },
              child: new Container(
                child: new GridView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(17.0),
                    itemCount: dataJson == null ? 0 : dataJson.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 3.7),
                    ),
                    itemBuilder: (context, i) {
                      if(dataJson == null) {
                        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(new HexColor("#20639B"))),);
                      } else {
                        return (i == dataJson.length ) ?
                        Container(
                          color: Colors.greenAccent,
                          child: FlatButton(
                            child: Text("Load More"),
                            onPressed: () {},
                          ),
                        )
                        :
                        new InkWell(
                          onTap: () {
                            //info.openApps(context, dataJson[i]['link']);
                          },
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Stack(
                                children: <Widget>[
                                  AspectRatio(
                                      aspectRatio: 27/14,
                                      child: new DecoratedBox(decoration:
                                      new BoxDecoration(
                                          borderRadius: new BorderRadius.all(Radius.circular(15)),
                                          shape: BoxShape.rectangle,
                                          image: new DecorationImage(image: new AssetImage('images/birthday.png'), fit: BoxFit.cover)
                                      )
                                      )
                                  ),

                                  new Container(
                                    margin: const EdgeInsets.only(top: 10, right: 20),
                                    alignment: Alignment.topRight,
                                    child: new Text('arz', style: new TextStyle(fontWeight: FontWeight.bold),),
                                  ),

                                  new Container(
                                    margin: const EdgeInsets.only(top: 30, right: 20),
                                    alignment: Alignment.topRight,
                                    child: new Text('corporate', style: new TextStyle(fontWeight: FontWeight.bold),),
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
                ),
              )
          )
              :
          new Container(
              alignment: Alignment.center,
              child: new Center(
                child: new Container(
                  //padding: const EdgeInsets.all(10.0),
                    child: new Text('No data in list')
                ),
              )
          ),
        )
    );
  }
}