import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/employe/requestattendance.dart';
import 'package:hsgfamily/loading.dart';
import 'package:hsgfamily/request/requestapproved.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:intl/intl.dart';

class RequestEmployee extends StatefulWidget {

  final String empid, empname;

  RequestEmployee({this.empid, this.empname});

  _RequestEmployee createState() => _RequestEmployee(empid: empid, empname: empname);
}

class _RequestEmployee extends State<RequestEmployee> {

  Size size;
  String message, empid, select, flag, empname, formattedDate, viewType, viewDate, viewKode, id, namaEmp;
  List dataJson;
  var now = new DateTime.now();

  Info info = new Info();
  Domain domain = new Domain();

  TextEditingController textEmpId = new TextEditingController();

  _RequestEmployee({this.empid, this.empname});

  Future<String> getData() async {

    http.Response hasil = await http.get(
        Uri.encodeFull("http://"+domain.getDomain()+"/loaddata.php?action=getRequestEmp&empid="+empid),
        headers:{ "Accept": "application.json" }
    );

    this.setState(() {
      dataJson = jsonDecode(hasil.body);
    });

    message = dataJson == null ? '1' : dataJson[0]['empid'];
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    formattedDate = new DateFormat('yyyy-MM-dd').format(now);

    this.getData();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 1.1,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text('Request Employe', style: new TextStyle(fontWeight: FontWeight.w600),),
        // actions: [
        //   new IconButton(
        //       icon: new Icon(Icons.add),
        //       onPressed: (){
        //         setState(() {
        //           Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new RequestAttendance()));
        //         });
        //       }
        //   ),
        // ],
      ),
      backgroundColor: Colors.white,
      body: message == null ? new Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: new ColorLoader(),
      ) : message == '1' ? new Container(
        margin: const EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: new Text('No data list', style: new TextStyle(fontSize: 20, fontWeight: FontWeight.w300),),
      )
          :new Stack(
        children: <Widget>[
          new Container(
            color: Colors.white,
            //margin: const EdgeInsets.only(top: 10),
            child: new Scrollbar(
              child: new RefreshIndicator(
                onRefresh: getData,
                child: new ListView.builder(
                  itemCount: dataJson == null ? 0 : dataJson.length,
                  itemBuilder: (context, i) {
                    return new InkWell(
                      onTap: (){
                        setState(() {
                          flag = 'app';
                          viewType = dataJson[i]['leavetype'];
                          viewDate = dataJson[i]['datecreate'];
                          viewKode = dataJson[i]['kode'];
                          id       = dataJson[i]['empid'];
                          namaEmp  = dataJson[i]['emp_name'];

                          Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                          new RequestApproved(empId: id, empname: empname, kode: viewKode, empApp: empid, cekId: empid,)));

                        });
                      },
                      child: new Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 10),
                        child: new ListTile(
                          leading: new Container(
                            child: new CircleAvatar(
                              backgroundImage: dataJson[i]['pict'] == 'M' ? new AssetImage('images/male.png') :
                              dataJson[i]['pict'] == 'F' ? new AssetImage('images/female.png') : new AssetImage('images/male.png'),
                              radius: 30.0,
                            ),
                          ),
                          title: new Text(dataJson[i]['leavetype']),
                          subtitle: new Text(dataJson[i]['emp_name']),
                          trailing: new Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
