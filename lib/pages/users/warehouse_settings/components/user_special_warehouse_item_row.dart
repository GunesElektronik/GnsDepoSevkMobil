import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/order_header_response_new.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/user_special_settings.dart';

// ignore: must_be_immutable
class UserSpecialWarehouseItemRow extends StatefulWidget {
  UserSpecialWarehouseItemRow({
    super.key,
    required this.item,
    required this.isSelected,
    required this.index,
    required this.isSelectedBefore,
  });

  @override
  State<UserSpecialWarehouseItemRow> createState() =>
      _UserSpecialWarehouseItemRowState();
  WorkplaceDepartmentWarehouse item;
  int index;
  final ValueChanged<bool?> isSelected;
  bool isSelectedBefore;
}

class _UserSpecialWarehouseItemRowState
    extends State<UserSpecialWarehouseItemRow> {
  // bool isChecked = false;
  late bool isChecked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = widget.isSelectedBefore;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        color: const Color.fromARGB(255, 230, 220, 202),
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
            leading: Text(
              widget.index < 10 ? '0${widget.index}' : widget.index.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            title: Text(
              widget.item.warehouse,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.item.workplace} - ${widget.item.department}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IsSelectedclassSalesOrderSummaryItem {
  OrderSummaryItem item;
  bool isSelected;

  IsSelectedclassSalesOrderSummaryItem(this.item, this.isSelected);
}
