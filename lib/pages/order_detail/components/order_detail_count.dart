import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/order_detail_count_mode.dart';
import 'package:gns_warehouse/pages/order_detail/components/order_detail_count_item.dart';

class OrderDetailCount extends StatefulWidget {
  OrderDetailCount(
      {super.key,
      required this.orderDetailCountList,
      required this.scannedBarcode});
  List<OrderDetailCountModel> orderDetailCountList;
  String scannedBarcode;
  @override
  State<OrderDetailCount> createState() => _OrderDetailCountState();
}

class _OrderDetailCountState extends State<OrderDetailCount> {
  Color secondaryColor = const Color.fromARGB(255, 58, 58, 58);

  String infoForBarcode = "";
  bool isFindAnyBarcode = false;
  bool _isBarcodeMatch(List<OrderDetailCountModel> list) {
    for (var orderItem in list) {
      if (orderItem.barcode == widget.scannedBarcode) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    isFindAnyBarcode = _isBarcodeMatch(widget.orderDetailCountList);
    if (isFindAnyBarcode == true) {
      infoForBarcode = "Barkod Bulundu !";
    } else {
      infoForBarcode = "Barkod Bulunamadı !";
    }

    if (widget.scannedBarcode == "") {
      infoForBarcode = "";
    }
    return Container(
      width: deviceWidth,
      color: const Color.fromARGB(255, 241, 241, 241),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              infoForBarcode,
              style: TextStyle(
                  color: selectColor(isFindAnyBarcode),
                  fontWeight: FontWeight.w700),
            ),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: widget.orderDetailCountList.length,
                itemBuilder: (context, index) {
                  return OrderDetailCountItem(
                      scannedBarcode: widget.scannedBarcode,
                      item: widget.orderDetailCountList[index]);
                }),
          ],
        ),
      ),
    );
  }

  Color selectColor(bool isFindAnyBarcode) {
    if (isFindAnyBarcode) {
      return Colors.green;
    }
    return Colors.red;
  }
}
