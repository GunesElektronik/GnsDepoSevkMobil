import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/sales_waybills_response.dart';
import 'package:gns_warehouse/pages/waybills/waybills_order_detail.dart';
import 'package:intl/intl.dart';

class WaybillsOrderList extends StatefulWidget {
  WaybillsOrderList({super.key, required this.response, required this.addMoreButtonClicked});

  @override
  State<WaybillsOrderList> createState() => _WaybillsOrderListState();
  List<SalesWaybillsItems>? response;
  void Function()? addMoreButtonClicked;
}

class _WaybillsOrderListState extends State<WaybillsOrderList> {
  late List<SalesWaybillsItems>? response;

  @override
  void didUpdateWidget(covariant WaybillsOrderList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.response != widget.response) {
      response = widget.response;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    response = widget.response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              primary: false,
              padding: const EdgeInsets.all(8),
              itemCount: response!.length + 1 ?? 0,
              itemBuilder: (context, index) {
                if (index == response!.length) {
                  return Column(
                    children: [
                      _addMoreDataButton(),
                      const SizedBox(height: 5),
                    ],
                  );
                }
                return _row(response![index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  TextButton _addMoreDataButton() {
    return TextButton(
      onPressed: widget.addMoreButtonClicked,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        'Daha Fazla Yükle',
        style: TextStyle(
            color: Colors.deepOrange, // Metin rengi
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Padding _row(SalesWaybillsItems item) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: _getColorBasedOnErpSendMessage(item.erpSendMessage.toString()),
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6),
          minVerticalPadding: 1,
          leading: Container(
            width: 60,
            height: 78,
            alignment: Alignment.center,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Text(
                    item.waybillStatus ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          title: Text(
            "#${item.ficheNo}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "D: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${item.warehouse}",
                        style: const TextStyle(fontSize: 13),
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "F.No: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Flexible(
                    flex: 2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        item.orderFicheNo!,
                        style: const TextStyle(fontSize: 13),
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Tarih: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.ficheDate!))} Saat: ${DateFormat('HH:mm:ss').format(DateTime.parse(item.ficheDate!))}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // trailing: const Icon(
          //   Icons.supervised_user_circle_outlined,
          //   color: Colors.black45,
          //   size: 24,
          // ),
          trailing: Text(
            _modifyErpSendMessage(item.erpSendMessage.toString()),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          //isThreeLine: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WaybillOrderDetail(
                          waybillId: item.waybillId!,
                          erpSendMessage: item.erpSendMessage.toString(),
                          erpColor: _getColorBasedOnErpSendMessage(item.erpSendMessage.toString()),
                        ))).then((value) async {});
          },
          onLongPress: () {},
          dense: true,
        ),
      ),
    );
  }

  Color _getColorBasedOnErpSendMessage(String erpSendMessage) {
    switch (erpSendMessage) {
      case 'Beklemede':
        return const Color.fromARGB(255, 144, 202, 249);
      case 'Gönderildi':
        return const Color.fromARGB(255, 249, 238, 144);
      case 'Başarılı':
        return const Color.fromARGB(255, 165, 249, 144);
      case 'null':
        return const Color.fromARGB(255, 207, 207, 207);
      default:
        return const Color.fromARGB(255, 250, 108, 108);
    }
  }

  String _modifyErpSendMessage(String erpSendMessage) {
    switch (erpSendMessage) {
      case 'Beklemede':
        return 'Beklemede';
      case 'Gönderildi':
        return 'Gönderildi';
      case 'Başarılı':
        return 'Başarılı';
      case 'null':
        return '';
      default:
        return 'Hata';
    }
  }
}
