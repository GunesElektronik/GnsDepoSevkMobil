import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

import '../models/setting_model.dart';
import '../repositories/loginrepository.dart';
import '../services/sharedpreferences.dart';
import 'login.dart';

class ScanSettingBarcode extends StatefulWidget {
  const ScanSettingBarcode({super.key});

  @override
  State<ScanSettingBarcode> createState() => _ScanSettingBarcodeState();
}

class _ScanSettingBarcodeState extends State<ScanSettingBarcode> {
  String scannedQr = "";
  String message = "Kurulum için Ayar QR'ını Okutunuz.";

  void initState() {
    super.initState();
    //scanQRCode();
  }

  Future<void> scanQRCode() async {
    try {
      bool isSuccess = false;
      bool isSecure = false;

      await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR).then((value) => {
            if (value == "-1")
              {
                setState(() {
                  message = "QR Kod Bulunamadı";
                  scannedQr = "None";
                })
              }
            else if (value.length > 0 || value.trim() != "-1")
              {
                isSuccess = true,
                setState(() {
                  message = "QR Kod Okundu!";
                  scannedQr = value;
                })
              }
          });

      if (isSuccess) {
        Map<String, dynamic> json = jsonDecode(scannedQr);
        SettingResult result = SettingResult.fromJson(json);

        if ((result.apiUrl?.length ?? 0) > 0) {
          LoginRepository repository = LoginRepository();

          var aliveresult = await repository.checkApi(result.apiUrl);
          //var aliveresult = true;

          if (aliveresult == true) {
            ServiceSharedPreferences.setSharedString("apiUrl", result.apiUrl.toString());

            Navigator.of(context).pop();

            await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Login(),
            ));
          } else {
            setState(() {
              message = "QR Koddan Ayar Bilgisi Alınamadı";
            });
          }
        }
      }
    } on PlatformException {
      setState(() {
        message = 'Platform Versiyonu Uyumsuz.';
      });
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.amber, //change your color here
          ),
          title: const Text(
            "QR Oku",
            style: TextStyle(color: Color(0XFF8a9d9c), fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  scanQRCode();
                },
                icon: const Icon(Icons.qr_code_outlined),
                iconSize: 30),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            elevation: 10,

            onPressed: () async {
              scanQRCode();
              /*
              Navigator.of(context).pop();
              await Navigator.of(context).push<String>(MaterialPageRoute(
                builder: (context) => const Home(),
              ));
              */
            },
            backgroundColor: Colors.orange, //
            child: const Icon(
              Icons.qr_code_outlined,
              color: Color(0XFFFFFFFF),
              size: 32,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: Text(
                    scannedQr,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    child: Text(message),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
