import 'package:flutter/material.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_control.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/drawer_menu.dart';
import 'package:gns_warehouse/widgets/gns_drawer_menu.dart';

class PurchaseOrder extends StatefulWidget {
  const PurchaseOrder({super.key});

  @override
  State<PurchaseOrder> createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {
  String employeeName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParameter();
  }

  void getParameter() async {
    employeeName =
        await ServiceSharedPreferences.getSharedString("EmployeeName") ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: drawerMenu(context, employeeName),
      drawer: GNSDrawerMenu(
        employeeName: employeeName,
      ),
      appBar: _appBar(),
      floatingActionButton: _floatActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoText(),
              const SizedBox(
                height: 30,
              ),
              _scanArea(),
              const SizedBox(
                height: 30,
              ),
              _button(
                "İrsaliyeyi Kontrol Et",
                Colors.white,
                const Color(0xffff9700),
                0.0,
                const Color.fromARGB(0, 255, 153, 0),
                () {},
              ),
              const SizedBox(
                height: 10,
              ),
              _button(
                "İrsaliye Oluştur",
                const Color(0xffff9700),
                Colors.white,
                2.0,
                const Color(0xffff9700),
                () {
                  Navigator.of(context).push<String>(MaterialPageRoute(
                    builder: (context) => const PurchaseOrderControl(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton _floatActionButton() {
    return FloatingActionButton(
      onPressed: () async {},
      backgroundColor: Colors.orange,
      elevation: 4,
      child: const Icon(
        Icons.qr_code_2_rounded,
        color: Color(0XFFFFFFFF),
        size: 30,
      ),
    );
  }

  Text _infoText() {
    return const Text(
      "Satın Alma İrsaliyesini Okutunuz",
      style: TextStyle(
          color: Color(0xff6f6f6f), fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Container _scanArea() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xfff1f1f1),
        borderRadius: BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.qr_code_2_rounded,
                color: Color(0xff8a9a99),
              )),
          Expanded(
            child: TextField(
              //autofocus: true,
              onSubmitted: (value) {
                if (value.isNotEmpty) {}
                //FocusScope.of(context).requestFocus(FocusNode());
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: const Color(0xff8a9a99),
            ),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              iconSize: 30,
              onPressed: () {},
              icon: const Icon(Icons.content_paste_search_rounded,
                  color: Colors.black)),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        'SATIN ALMA SİPARİŞİ',
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.bold,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  Row _button(String content, Color textColor, Color backgroundColor,
      double borderWidth, Color borderColor, VoidCallback? onPressed) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(backgroundColor),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: borderColor, // Kenarlık rengi
                  width: borderWidth, // Kenarlık kalınlığı
                ),
              ),
            ),
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                content,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
