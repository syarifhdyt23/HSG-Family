import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/empprofile.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Friend extends StatefulWidget {

  final String empid;

  Friend({this.empid});

  _Friend createState() => _Friend(empid: empid);
}

class _Friend extends State< Friend> {

  Size size;
  String message, empid;
  List dataJson, searchJson;
  bool search = false;

  Domain domain = new Domain();

  TextEditingController textEmpId = new TextEditingController();

  _Friend({this.empid});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getFriend&empid="+empid),
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
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text('Friend',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      ),

      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new Stack(
          children: <Widget>[
            message == null ? new Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: new ColorLoader(),
            ) : message == '1' ? new Container(
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: new Text('No data list', style: new TextStyle(fontSize: 20, fontWeight: FontWeight.w300),),
            )
                :new Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 60),
              child: new Scrollbar(
                child: new RefreshIndicator(
                  onRefresh: getData ,
                  child: new Container(
                  child: search == false ? new ListView.builder(
                    itemCount: dataJson == null ? 0 : dataJson.length,
                    itemBuilder: (context, i) {
                      return new ListTile(
                        leading: new Container(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: new CircleAvatar(
                            backgroundImage: dataJson[i]['pict'] == 'M' ? new AssetImage('images/male.png') :
                            dataJson[i]['pict'] == 'F' ? new AssetImage('images/female.png'):
                            new AssetImage('images/male.png'),
                            radius: 27.0,
                          ),
                        ),
                        title: new Text(dataJson[i]['emp_name'], style: new TextStyle(fontWeight: FontWeight.w600),),
                        subtitle: new Text(dataJson[i]['level']),
                        trailing: new Container(
                          height: 30,
                          width: 70,
                          child: new FlatButton(
                            onPressed: (){
                              Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                              new EmpProfile(gender: dataJson[i]['pict'], empName: dataJson[i]['emp_name'], empId: dataJson[i]['emp_id'], edit: false, flag: dataJson[i]['emp_id'],)));
                            },
                            child: new Text('View', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),),
                            color: new HexColor("#2771A3"),
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                        ),
                      );
                    },
                  ) :
                  new ListView.builder(
                    itemCount: searchJson == null ? 0 : searchJson.length,
                    itemBuilder: (context, i) {
                      return new ListTile(
                        leading: new Container(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: new CircleAvatar(
                            backgroundImage: searchJson[i]['pict'] == 'M' ? new AssetImage('images/male.png') :
                            searchJson[i]['pict'] == 'F' ? new AssetImage('images/female.png'):
                            new AssetImage('images/male.png'),
                            radius: 27.0,
                          ),
                        ),
                        title: new Text(searchJson[i]['emp_name'], style: new TextStyle(fontWeight: FontWeight.w600),),
                        subtitle: new Text('Employe'),
                        trailing: new Container(
                          height: 30,
                          width: 70,
                          child: new FlatButton(
                            onPressed: (){
                              Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                              new EmpProfile(gender: searchJson[i]['pict'], empName: searchJson[i]['emp_name'], empId: searchJson[i]['emp_id'], edit: false)));
                            },
                            child: new Text('View', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),),
                            color: new HexColor("#2771A3"),
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                ),
              ),
            ),

            new Container(
              height: 60,
              width: size.width,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                  color: Colors.white
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: size.width,
                    height: 37,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: new TextField (
                      controller: textEmpId,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 0.0),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 7.0),
                        //border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                        labelStyle: TextStyle(color: Colors.black, ),
                        fillColor: Colors.grey[200],
                        prefixIcon: new Icon(Icons.search),
                        filled: true,
                      ),
                      onSubmitted: (String scr) {
                        setState(() {
                          search = false;
                          textEmpId.clear();
                          searchJson = dataJson.where((item) {
                            var itemSearch = item['emp_name'].toLowerCase();
                            return itemSearch.contains('');
                          }).toList();
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                      onChanged: (val) {
                        setState(() {
                          search = true;
                          searchJson = dataJson.where((item) {
                            var itemSearch = item['emp_name'].toLowerCase();
                            return itemSearch.contains(val);
                          }).toList();
                        });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              )
            ),
          ],
        )
      )
    );
  }
}