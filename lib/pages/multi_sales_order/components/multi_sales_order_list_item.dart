import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/models/new_api/order_detail_new_model.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/multi_sales_order/components/multi_sales_order_control_card.dart';
import 'package:gns_warehouse/pages/multi_sales_order/components/multi_sales_order_list_item_row.dart';
import 'package:gns_warehouse/pages/purchase_orders/components/purchase_order_list_item_row.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:intl/intl.dart';

class MultiSalesOrderListItem extends StatefulWidget {
  MultiSalesOrderListItem({
    super.key,
    required this.item,
    required this.departments,
    required this.changedItem,
    required this.response,
  });
  IsSelectedclassSalesOrderSummaryItem item;
  List<Departments> departments;
  final ValueChanged<OrderDetailResponseNew> changedItem;
  final ValueChanged<OrderDetailResponseNew> response;
  @override
  State<MultiSalesOrderListItem> createState() =>
      _MultiSalesOrderListItemState();
}

class _MultiSalesOrderListItemState extends State<MultiSalesOrderListItem> {
  late bool isDataFetch;
  late ApiRepository apiRepository;
  late OrderDetailResponseNew response;
  DbHelper _dbHelper = DbHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
  }

  void _createApiRepository() async {
    isDataFetch = false;
    apiRepository = await ApiRepository.create(context);
    response = await apiRepository.getOrderDetail(widget.item.item.orderId!);
    widget.response(response);
    setState(() {
      isDataFetch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDataFetch
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${response.order!.ficheNo} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(response.order!.ficheDate!))} - ${response.order!.orderStatusName}",
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 165, 165, 165),
                thickness: 2,
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: response.order!.orderItems!.length,
                itemBuilder: (context, index) {
                  return MultiSalesOrderListItemRow(
                    item: response.order!.orderItems![index],
                    departments: widget.departments,
                    newWarehouseName: (value) {
                      response.order!.orderItems![index].warehouseName =
                          value ?? "";
                      //widget.changedItem(response);
                    },
                    newWarehouseId: (value) {
                      response.order!.orderItems![index].warehouseId =
                          value ?? "";
                      widget.changedItem(response);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
