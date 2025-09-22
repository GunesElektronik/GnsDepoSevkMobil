import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/pages/purchase_orders/components/purchase_order_scan_area.dart';
import 'package:gns_warehouse/pages/purchase_orders/components/purchase_order_scan_item_row.dart';

class PurchaseOrderScan extends StatefulWidget {
  const PurchaseOrderScan({super.key});

  @override
  State<PurchaseOrderScan> createState() => _PurchaseOrderScanState();
}

class _PurchaseOrderScanState extends State<PurchaseOrderScan> {
  String barcode = "";
  String seriOrBarcode = "barcode";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(context),
        body: PopScope(
          canPop: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _headerTextStage(),
                  const SizedBox(
                    height: 20,
                  ),
                  _listTile(
                    "IRS00000123",
                    "3",
                  ),
                  PurchaseOrderScanArea(
                    onBarcodeChanged: (value) {
                      if (value.toString().isNotEmpty) {
                        barcode = value!;
                      }
                      print("purchase order: $barcode");
                    },
                    seriOrBarcode: (value) {
                      seriOrBarcode = value;
                    },
                    scannedTimes: (value) {},
                  ),
                  _divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              //return const PurchaseOrderScanItem();
                              return PurchaseOrderScanItemRow();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  _button("Okuma Listesini Kaydet", Colors.white,
                      const Color(0xffff9700), () {}),
                  _button("Okuma Listesini Kaydet", Colors.white,
                      const Color(0xffe64a19), () {}),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  DefaultTabController _barcodeScanArea(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TabBar(
                padding: const EdgeInsets.only(bottom: 0),
                tabAlignment: TabAlignment.center,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: const Color(0xff959b9b),
                indicator: BoxDecoration(
                    color: const Color(0xfffef8ec),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.deepOrange, width: 1)),
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 3,
                dividerColor: Colors.deepOrange,
                tabs: const [
                  Tab(
                    child: Text(
                      "BARKOD OKU",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "SERİ / LOT OKU",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  _barcodeScanner(),
                  _seriAndLotScanner(),
                ]),
              )
            ],
          )),
    );
  }

  Row _barcodeScanner() {
    return Row(
      children: [
        //number
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    iconSize: 28,
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: Color(0xff8a9a99),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: TextField(
                      //controller: _numberController,
                      onSubmitted: (_) {
                        FocusScope.of(context).nextFocus();
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8a9a99),
                      ),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero),
                      cursorColor: const Color(0xff8a9a99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //space
        SizedBox(
          width: 10,
        ),
        //barcode
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.barcode_reader,
                      color: Color(0xff8a9a99),
                    )),
                Expanded(
                  child: TextField(
                    //focusNode: _barcodeFocusNode,
                    //autofocus: true,
                    //controller: _barcodeController,
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
                    iconSize: 38,
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _seriAndLotScanner() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.barcode_reader,
                      color: Color(0xff8a9a99),
                    )),
                Expanded(
                  child: TextField(
                    //focusNode: _barcodeFocusNode,
                    //autofocus: true,
                    //controller: _barcodeController,
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
                    iconSize: 38,
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "SATIN ALMA SİPARİŞİ",
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.w600,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 35,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  ListTile _listTile(String title, String number) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 0),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xff6a6a6a),
        ),
      ),
      trailing: Text(
        number,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange),
      ),
    );
  }

  Padding _headerTextStage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headerText("Kontrol", const Color(0xff919b9a)),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 25,
            color: Color(0xffd5d5d5),
          ),
          _headerText("Liste", const Color(0xff919b9a)),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 25,
            color: Color(0xffd5d5d5),
          ),
          _headerText("Okutma", Colors.deepOrange),
        ],
      ),
    );
  }

  Text _headerText(String content, Color color) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Divider _divider() {
    return const Divider(
      color: Color.fromARGB(255, 54, 54, 54),
      thickness: 0.8,
    );
  }

  Row _button(String content, Color textColor, Color backgroundColor,
      VoidCallback? onPressed) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(0),
                backgroundColor:
                    MaterialStateProperty.all<Color>(backgroundColor),
              ),
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
        ),
      ],
    );
  }
}
