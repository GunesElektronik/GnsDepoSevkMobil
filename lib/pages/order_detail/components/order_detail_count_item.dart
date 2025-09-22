import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/order_detail_count_mode.dart';

class OrderDetailCountItem extends StatefulWidget {
  OrderDetailCountItem(
      {super.key, required this.item, required this.scannedBarcode});

  OrderDetailCountModel item;
  String scannedBarcode;

  @override
  State<OrderDetailCountItem> createState() => _OrderDetailCountItemState();
}

class _OrderDetailCountItemState extends State<OrderDetailCountItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.item.barcode == widget.scannedBarcode) {
      if (widget.item.qty > widget.item.scannedQty) {
        widget.item.scannedQty++;
      }
    }
    //print(
    //   "Deneme-- ${widget.item.name}: ${widget.item.scannedQty}/${widget.item.qty}");

    return Card(
      color: Color.fromARGB(255, 249, 255, 215),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: _text(widget.item.name.toString(), FontWeight.w700,
                        20, Colors.black, TextAlign.start)),
                Expanded(
                    flex: 2,
                    child: _text(
                        "${widget.item.scannedQty}/${widget.item.qty}",
                        FontWeight.w700,
                        20,
                        selectColor(widget.item.scannedQty, widget.item.qty),
                        TextAlign.end)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: _text(widget.item.barcode.toString(),
                        FontWeight.w500, 17, Colors.grey, TextAlign.start)),
                Expanded(
                    flex: 2,
                    child: _text("Fiyat: 35", FontWeight.w500, 17, Colors.grey,
                        TextAlign.end)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color selectColor(int scannedQty, int qty) {
    if (scannedQty == 0) {
      return Colors.red;
    }
    if (scannedQty == qty) {
      return Colors.green;
    } else {
      return Colors.amber;
    }
  }

  Text _text(String title, FontWeight fontWeight, double fontSize,
      Color fontColor, TextAlign align) {
    return Text(
      title,
      textAlign: align,
      style: TextStyle(
          fontWeight: fontWeight, fontSize: fontSize, color: fontColor),
    );
  }

  Row _textForStart(String definition, FontWeight fontWeight, double fontSize,
      Color fontColor, double topPadding) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                definition,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                    color: fontColor),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Expanded _orderItemFicheMoney(
      String title,
      String money,
      Color color,
      double topLeftRadius,
      double topRightRadius,
      double bottomRightRadius,
      double bottomLeftRadius) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topLeftRadius),
                    topRight: Radius.circular(topRightRadius),
                    bottomLeft: Radius.circular(bottomLeftRadius),
                    bottomRight: Radius.circular(bottomRightRadius))),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    money,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )));
  }
}
