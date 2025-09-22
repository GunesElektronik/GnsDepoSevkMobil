import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';

class OrderControlCard extends StatefulWidget {
  OrderControlCard({super.key, required this.item, required this.isSelected});

  @override
  State<OrderControlCard> createState() => _OrderControlCardState();
  IsSelectedclassPurchaseOrderSummaryItem item;
  final ValueChanged<bool?> isSelected;
}

class _OrderControlCardState extends State<OrderControlCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        color: const Color(0xfff1f1f1),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.only(right: 0, left: 0),
            trailing: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      widget.isSelected(value);
                      isChecked = value!;
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: const Color(0xffff9700),
                  overlayColor: const MaterialStatePropertyAll<Color>(
                      Color.fromARGB(117, 233, 201, 154)),
                  side: const BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            leading: const Text(
              "1",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            title: Text(
              widget.item.item.ficheNo.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xff6a6a6a),
              ),
            ),
            subtitle: Text(
              widget.item.item.orderStatus.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xffaaaaaa),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IsSelectedclassPurchaseOrderSummaryItem {
  PurchaseOrderSummaryItem item;
  bool isSelected;

  IsSelectedclassPurchaseOrderSummaryItem(this.item, this.isSelected);
}
