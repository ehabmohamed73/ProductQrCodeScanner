import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrcodeScanner extends StatefulWidget {
  const QrcodeScanner({super.key});

  @override
  State<QrcodeScanner> createState() => _QrcodeScannerState();
}

class _QrcodeScannerState extends State<QrcodeScanner> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    scanQR();
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      // res = await getProuduct();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    res = await getProuduct();
    if (res['status'] == "success") {
      print("====================");
      print("===== ${res['data']['product_name']}");
      print("====================");
      setState(() {
        proName = res['data']['product_name'];
        proPrice = res['data']['product_price'];
      });
    }
  }

  getProuduct() async {
    try {
      var response = await http.post(
        Uri.parse("http://192.168.1.7/qrCode/viewcode.php"),
        body: {"product_num": _scanBarcode.toString()},
      );
      if (response.statusCode == 200) {
        var responsBody = jsonDecode(response.body);
        return responsBody;
      } else {
        print("Failed====${response.statusCode}");
      }
    } catch (e) {
      print("error in catch $e");
    }
  }

  var res;
  late String proName = "", proPrice = "";

  Widget buildProductName(String namePro) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ': اسم المنتج ',
              style: TextStyle(
                color: const Color(0xff000000),
                fontSize: ScreenHeight * 0.02,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inspiration',
                height: ScreenHeight * 0.005,
              ),
            ),
          ],
        ),
        Container(
          height: ScreenHeight * 0.15,
          width: ScreenWidth,
          //
          // alignment: Alignment.centerRight,
          // decoration: BoxDecoration(
          // color: const Color(0xffffffff),
          // borderRadius: BorderRadius.circular(10),
          // ),
          child: TextField(
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Color(0xcc000000),
            ),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xccb2b2b2),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xffCDDCE3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.fromLTRB(0, 14, 14, 14),
                hintText: namePro,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenHeight * 0.015,
                  fontFamily: 'Inspiration',
                ),
                helperStyle: const TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  Widget buildPrice(pricePro) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ': السعر ',
              style: TextStyle(
                color: const Color(0xff000000),
                fontSize: ScreenHeight * 0.02,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inspiration',
                height: ScreenHeight * 0.0025,
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenHeight * 0.15,
          width: ScreenWidth,
          //
          // alignment: Alignment.centerRight,
          // decoration: BoxDecoration(
          // color: const Color(0xffffffff),
          // borderRadius: BorderRadius.circular(10),
          // ),
          child: TextField(
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Color(0xcc000000),
            ),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xccb2b2b2),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xffCDDCE3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
                hintText: pricePro,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenHeight * 0.015,
                  fontFamily: 'Inspiration',
                ),
                helperStyle: const TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 253, 252, 252),
        elevation: 0,
        title: const Text(
          'النتيجة',
          style:
              TextStyle(fontFamily: 'Amiri', color: Colors.black, fontSize: 25),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          height: ScreenHeight * 0.06,
          width: ScreenWidth * 0.10,
          decoration: BoxDecoration(
            color: const Color(0xfffeae9d),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(0, 3),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextButton(
            onPressed: () async {
              await scanQR();
            },
            child: const Text(
              'الخلف',
              textAlign: TextAlign.center,
              style: TextStyle(

                  // fontWeight: FontWeight.w400,
                  // height: 1.2125 * ffem / fem,
                  color: Color(0xff000000),
                  fontSize: 20,
                  fontFamily: 'Inter'),
            ),
          ),
        ),
        leadingWidth: 90,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: buildProductName(proName),
            ),
            Container(
              child: buildPrice(proPrice),
            ),
          ],
        ),
      ),
    );
  }
}
