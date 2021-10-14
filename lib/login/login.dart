import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hsgfamily/domain.dart';
import 'package:hsgfamily/hexacolor.dart';
import 'package:hsgfamily/info.dart';
import 'package:hsgfamily/login/loadinglogin.dart';
import 'package:hsgfamily/login/verification.dart';

class Login extends StatefulWidget {

  _Login createState() => _Login();
}

class _Login extends State<Login>{

  Size size, message;
  List dataJson;
  Info info = new Info();
  Domain domain = new Domain();

  TextEditingController textEmpId = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;

    return new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new Container(
          child: new Stack(
            children: <Widget>[
              new Positioned(
                top: 150,
                left: .0,
                right: .0,
                height: 150,
                child: Image.asset('images/logologin.png'),
              ),

              new Positioned(
                top: size.height - 350,
                child: new Container(
                  width: size.width-10,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: new TextField (
                    controller: textEmpId,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 7.0),
                      //border: InputBorder.none,
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'helvetica'),
                      labelStyle: TextStyle(color: Colors.black, ),
                      suffixIcon: new Icon(Icons.phone_android),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),

                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),

              new Positioned(
                top: size.height - 310,
                child: new Container(
                  height: 45,
                  width: size.width-40,
                  margin: const EdgeInsets.only(top: 20, right: 25.0, bottom: 30, left: 20),
                  child: new FlatButton(
                      onPressed: (){
                        if(textEmpId.text == "") {
                          info.MessageInfo(context, 'Message', 'Please input your phone number');
                        }else {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) =>
                              new Verification(empId: textEmpId.text,), fullscreenDialog: true));
                        }
                      },
                      color: new HexColor("#005792"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(3.0),
                          side: new BorderSide(color: new HexColor("#005792"))
                      ),
                      child: new Text('Verify', style: new TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'helvetica'),)
                  ),
                ),
              )
            ],
          ),
        ),
    );

  }
}