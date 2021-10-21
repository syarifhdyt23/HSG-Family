import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../loading.dart';

class Peraturan extends StatefulWidget {
  final String linkPdf, title;

  Peraturan({Key key, this.linkPdf, this.title}) : super(key: key);

  _Peraturan createState() => new _Peraturan(linkPdf: linkPdf, title: title);
}

class _Peraturan extends State<Peraturan> {

  bool isLoading = true;
  String linkPdf, title;
  WebViewController _webViewController;

  _Peraturan({this.linkPdf, this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: new Text(title,style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      ),

      body: new Stack(
        children: [
          new WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: linkPdf,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageFinished: (finish){
              setState(() {
                isLoading = false;
              });
            },
          ),
          // isLoading != true ? new Container(
          //   color: Colors.white,
          //   alignment: Alignment.center,
          //   child: new ColorLoader(),
          // ) : new Container(),
        ],
      )
    );
  }
}