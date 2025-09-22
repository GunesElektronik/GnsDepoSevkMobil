import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PurchaseOrderScanItemRow extends StatefulWidget {
  const PurchaseOrderScanItemRow({super.key});

  @override
  State<PurchaseOrderScanItemRow> createState() =>
      _PurchaseOrderScanItemRowState();
}

class _PurchaseOrderScanItemRowState extends State<PurchaseOrderScanItemRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Köşeleri yuvarlatılmış bir kart
            ),
            color: const Color(0xfff1f1f1),
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                contentPadding: const EdgeInsets.only(right: 10, left: 10),
                leading: Text(
                  "N",
                  style: _textStyle(
                      17, FontWeight.normal, const Color(0xff707070)),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "10 / 15",
                      style:
                          _textStyle(18, FontWeight.bold, selectColor(10, 15)),
                    ),
                  ],
                ),
                title: Text(
                  "2BT1024 - 8499904780318",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      _textStyle(14, FontWeight.w700, const Color(0xff717171)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ttec blutooth kablosuz kulaklık -mavi",
                      style: _textStyle(
                          12, FontWeight.normal, const Color(0xff707070)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  Color selectColor(int scannedQty, int qty) {
    if (scannedQty == 0) {
      return const Color(0xff939d9c);
    }
    if (scannedQty == qty) {
      return const Color(0xff20c0d8);
    } else {
      return const Color(0xffd0552b);
    }
  }
}
