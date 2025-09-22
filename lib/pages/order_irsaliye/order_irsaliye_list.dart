import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/pages/order_irsaliye/order_irsaliye_scan.dart';
import 'package:gns_warehouse/pages/purchase_orders/components/purchase_order_list_item.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_scan.dart';
import 'package:intl/intl.dart';
/*
class IrsaliyeOrderList extends StatefulWidget {
  const IrsaliyeOrderList({super.key});

  @override
  State<IrsaliyeOrderList> createState() => _IrsaliyeOrderListState();
}

class _IrsaliyeOrderListState extends State<IrsaliyeOrderList> {
  var deneme = [1, 5, 3];
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
                    "12.03.2024",
                  ),
                  _divider(),
                  _listTile(
                      "120.08.0001", "Güneş Elktronik Cihazlar Tic. Ltd..."),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return PurchaseOrderListItem(
                                itemRowDeneme: deneme[index],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _button("Toplama Listesini Kaydet", Colors.white,
                        const Color(0xffff9700), () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _button("Toplama Listesini Topla", Colors.white,
                        const Color(0xffff9700), () {
                      Navigator.of(context).push<String>(MaterialPageRoute(
                        builder: (context) => const IrsaliyeOrderScan(),
                      ));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: _button("İrsaliye Oluştur / Güncelle", Colors.white,
                        const Color(0xffe64a19), () {}),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "SATIŞ SİPARİŞİ",
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

  ListTile _listTile(String title, String subtitle) {
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
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 15,
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
          _headerText("Liste", Colors.deepOrange),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 25,
            color: Color(0xffd5d5d5),
          ),
          _headerText("Okutma", const Color(0xff919b9a)),
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
      color: Color.fromARGB(255, 228, 228, 228),
      thickness: 1,
    );
  }

  Row _button(String content, Color textColor, Color backgroundColor,
      VoidCallback? onPressed) {
    return Row(
      children: [
        Expanded(
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
      ],
    );
  }
}
*/