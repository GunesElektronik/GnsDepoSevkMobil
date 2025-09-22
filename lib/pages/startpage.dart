import 'package:flutter/material.dart';
import 'package:gns_warehouse/pages/scan_setting.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                SizedBox(
                  height: 190,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 0),
                  child: Text("GNS",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFFFFFFF))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 10),
                  child: Text("Depo Yönetim Sistemi",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFFFFFFF))),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "V 1.0",
                    style: TextStyle(color: Color(0xFFffffff)),
                  ),
                ),
                /* Padding(
                  padding: const EdgeInsets.symmetric(vertical : 20.0),
                  child: SvgPicture.asset(
                    'assets/svg/logo.svg',
                    height: 50,
                  ),
                ),*/
              ],
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const ScanSettingBarcode();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.amber),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text("Haydi Başlayalım...",
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 60.0, top: 20),
                  child: Text(
                    "Güneş Elektronik Ltd. Şti. ",
                    style: TextStyle(fontSize: 12, color: Color(0XFFFFFFFF)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
