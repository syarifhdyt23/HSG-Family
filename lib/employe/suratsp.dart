import 'dart:typed_data';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';

class SP extends StatefulWidget {
  String nama, jabatan, numberSP, tgl;
  SP({this.jabatan, this.nama, this.numberSP, this.tgl});
  @override
  _SPState createState() => _SPState(jabatan: jabatan, nama: nama, numberSP: numberSP, tgl:tgl);
}

class _SPState extends State<SP> {
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  Size size;
  var now, formatter;
  String nama, jabatan, numberSP, jenisSP, urutanSP, formattedDate, tgl, tambahSP;

  _SPState({this.jabatan, this.nama, this.numberSP, this.tgl});

  // createPDF(Uint8List capturedImage) async {
  //   for (var img in capturedImage) {
  //     final image = pw.MemoryImage(img.readAsBytesSync());
  //
  //     pdf.addPage(pw.Page(
  //         pageFormat: PdfPageFormat.a4,
  //         build: (pw.Context contex) {
  //           return pw.Center(child: pw.Image(image));
  //         }));
  //   }
  // }
  //
  // savePDF() async {
  //   try {
  //     final dir = await getExternalStorageDirectory();
  //     final file = File('${dir.path}/filename.pdf');
  //     await file.writeAsBytes(await pdf.save());
  //     showPrintedMessage('success', 'saved to documents');
  //   } catch (e) {
  //     showPrintedMessage('error', e.toString());
  //   }
  // }
  //
  // showPrintedMessage(String title, String msg) {
  //   Flushbar(
  //     title: title,
  //     message: msg,
  //     duration: Duration(seconds: 3),
  //     icon: Icon(
  //       Icons.info,
  //       color: Colors.blue,
  //     ),
  //   )..show(context);
  // }

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 300.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      return doc.save();
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot",style: TextStyle(color: Colors.black),),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      jenisSP = numberSP == 'SP1' ? 'Pertama' : numberSP == 'SP2' ? 'Kedua' : 'Ketiga';
      urutanSP = numberSP == 'SP1' ? '1' : numberSP == 'SP2' ? '2' : '3';
      tambahSP = numberSP == 'SP1' ? 'Kedua' : 'Ketiga';
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(tgl);
      var inputDate = DateTime.parse(parseDate.toString());
      formatter = new DateFormat('dd MMMM yyyy');
      formattedDate = formatter.format(inputDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text('Surat Peringatan',style: new TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
        actions: [
          new Padding(
            padding: EdgeInsets.only(right: 15),
            child: new InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: const Icon(Icons.print),
              onTap: _printScreen,
            ),
          ),
        ],
      ),
      // bottomNavigationBar: FloatingActionButton(
      //   child: const Icon(Icons.print),
      //   onPressed: _printScreen,
      // ),
      body: RepaintBoundary(
        key: _printKey,
        // child: Screenshot(
        //   controller: screenshotController,
          child: new Stack(
            children: [
              // new Image(image: AssetImage('images/sp.png')),
              new Container(
                // height: 600,
                color: Colors.white,
                alignment: Alignment.center,
                child: new Column(
                  children: [
                    new Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 25),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Expanded(
                            flex:1,
                            child: new Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              child: new Image(image: AssetImage('images/logohsg.png')),
                            ),
                          ),
                          new Expanded(
                              flex: 4,
                              child: new Container(
                                height: 40,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text('PT. HELIHAN SURYA GEMILANG',style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                                    new Text('Jl.RS.Soekanto No.1 RT.009/RW.012, Duren Sawit - Jakarta Timur\nPhone: 021-86608940',
                                      style: TextStyle(
                                          fontSize: 7),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    new Divider(
                      height: 10,
                      thickness: 2,
                      color: Colors.blueAccent,
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 10),
                      child: new Column(
                        children: [
                          new Text('SURAT PERINGATAN '+jenisSP.toUpperCase()+' (SP-$urutanSP)',style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,decoration: TextDecoration.underline),),
                          new Text('No: 031/HSG-SP/X/2021',
                            style: TextStyle(
                                fontSize: 9),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: new Text('Surat peringatan ini diberikan kepada:\n\n'
                          '   Nama       : $nama\n'
                          '   Jabatan   : $jabatan\n\n'
                          'Surat Peringatan '+jenisSP+' (SP-$urutanSP) ini diterbitkan berdasarkan hasil laporan absensi perusahaan bahwa telah terjadi'
                          'tindakan indisipliner yang telah saudara lakukan, yaitu Telat .. dan Tidak hadir ..\n\n'
                          'Sebagai seorang karyawan, sudah menjadi keharusan bagi saudara untuk mematuhi peraturan yang diberikan oleh perusahaan.\n\n'
                          'Tujuan dari Surat Peringatan '+jenisSP+' ini adalah untuk memberikan arahan serta peringatan agar '
                          'saudara dapat mentaati tata tertib yang berlaku pada perusahaan dan tidak melakukan kesalahan'
                          'yang sama. Bila di bulan berikutnya saudara mencapai atau melewati ketentuan SP-'+(int.parse(urutanSP)+1).toString()+' maka '
                          'perusahaan akan memberikan Surat Peringatan $tambahSP (SP-'+(int.parse(urutanSP)+1).toString()+').\n\n'
                          'Demikian Surat Peringatan '+jenisSP+' ini diterbitkan agar menjadi pengingat dan perhatian saudara.\n\n'
                          'Jakarta, $formattedDate',
                        style: TextStyle(fontSize: 9,),textAlign: TextAlign.justify,),
                    ),
                    new Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 50, left: 15),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Text('Lee Handoko',style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,decoration: TextDecoration.underline),),
                          new Text('Direktur Utama',
                            style: TextStyle(
                                fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      // )
    );
  }
}
