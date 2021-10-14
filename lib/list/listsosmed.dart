import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:hsgfamily/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ListSosMed extends StatefulWidget {

  _ListSosMed createState() => _ListSosMed();
}

class _ListSosMed extends State<ListSosMed> {

  String message;
  List dataJson;
  int itemNumb = 10;
  Size size;


  Info info = new Info();
  Domain domain = new Domain();

  Future<String> getData(String limit) async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getSosMed&param=limit "+limit),
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
        title: new Text('Social Media'),
      ),

      backgroundColor: Colors.grey[200],
      body: new Container(
        child: message == null ?
        new Stack(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 35),
              child: new FlareActor('assets/loadinggears.flr', alignment: Alignment.center, fit: BoxFit.contain, animation: 'animationgear',),
            ),

            new Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 50),
              child: new Text('Loading...', style: new TextStyle(fontSize: 17, fontFamily: 'proxinovaregular', fontWeight: FontWeight.w600),),
            )
          ],
        )
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
                        (MediaQuery.of(context).size.height / 3.2),
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
                          info.openApps(context, dataJson[i]['link']);
                        },
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                AspectRatio(
                                    aspectRatio: 10 / 4.6,
                                    child: new DecoratedBox(decoration:
                                    new BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0)),
                                        shape: BoxShape.rectangle,
                                        image: new DecorationImage(
                                            image: new NetworkImage(dataJson == null ? new AssetImage('images/noimage.png') : dataJson[i]['image']),
                                            fit: BoxFit.fill)
                                    )
                                    )
                                ),
                              ],
                            ),

                            new Container(
                              width: size.width,
                              padding: const EdgeInsets.only(top: 10.0,),
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
                                    child: new Text(dataJson == null ? '' : dataJson[i]['titlepromo'],
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15), maxLines: 2, softWrap: true,
                                    ),
                                  ),

                                  new Container(
                                    padding: const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0, bottom: 10.0),
                                    child: new Text(dataJson == null ? '' : dataJson[i]['subtitlepromo'],
                                      style: TextStyle(color: Colors.grey, fontSize: 15), maxLines: 2, softWrap: true,
                                    ),
                                  ),

                                ],
                              ),
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