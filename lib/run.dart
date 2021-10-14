import 'package:flutter/material.dart';
import 'package:hsgfamily/employe/absensi.dart';
import 'package:hsgfamily/employe/home.dart';
import 'package:hsgfamily/employe/requestattendance.dart';
import 'package:hsgfamily/iconshsg.dart';
import 'package:hsgfamily/request/requestemployee.dart';
import 'friend/friend.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hsgfamily/domain.dart';
import 'hexacolor.dart';
import 'info.dart';

class Run extends StatefulWidget {

  Run({this.empId, this.empname});

  final String empId, empname;

  _Run createState() => _Run(empId: empId, empname: empname);
}

class _Run extends State<Run> {

  int _selectedIndex = 0;
  String message, identifier, email, empId, flag, empname;
  List deviceJson, dataJson, emailJson;
  Timer timer;
  bool isKeyboardVisible;
  Info info = new Info();
  Domain domain = new Domain();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  List<Widget> pageList = List<Widget>();

  _Run({this.empId, this.empname});

  @override
  void initState() {
    // TODO: implement initState
    pageList.add(new Home(empId: empId,));
    pageList.add(new Friend(empid: empId,));
    pageList.add(new RequestEmployee(empid: empId, empname: empname));
    //pageList.add(new Absensi(empid: empId,));

    super.initState();

    flag = 'list';

    isKeyboardVisible = KeyboardVisibility.isVisible;
    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),

      bottomNavigationBar: new BottomNavigationBar(
          onTap: (index){
            _onItemTap(index);
          },

          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
                icon: new Icon(IconsHSG.home_new),
                title: Padding(padding: EdgeInsets.all(0),)
            ),

            BottomNavigationBarItem(
                icon: new Icon(IconsHSG.person2),
                title: Padding(padding: EdgeInsets.all(0),)
            ),

            BottomNavigationBarItem(
                icon: new Icon(IconsHSG.star),
                title: Padding(padding: EdgeInsets.all(0),)
            ),

            /*BottomNavigationBarItem(
                icon: new Icon(Icons.calendar_today),
                title: Padding(padding: EdgeInsets.all(0),)
            ),*/
          ],

          currentIndex: _selectedIndex,
          selectedItemColor: new HexColor("#2771A3"),
          backgroundColor: Colors.white,
      ),
    );
  }
}