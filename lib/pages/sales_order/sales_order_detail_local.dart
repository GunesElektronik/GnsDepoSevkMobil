import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/models/new_api/order_header_response_new.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/pages/order_detail/order_scan_page.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:intl/intl.dart';

class SalesOrderDetailLocal extends StatefulWidget {
  const SalesOrderDetailLocal({super.key, required this.item});

  final OrderSummaryItem item;
  @override
  State<SalesOrderDetailLocal> createState() => _SalesOrderDetailLocalState();
}

class _SalesOrderDetailLocalState extends State<SalesOrderDetailLocal> {
  List<OrderDetailItemDB>? orderDetailItemList = [];
  final DbHelper _dbHelper = DbHelper.instance;
  bool isPriceVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocalOrderDetailItemList();
  }

  List<OrderDetailItemDB> sortOrderDetailItems(List<OrderDetailItemDB> items) {
    // Yeni bir kopya oluşturup sıralıyoruz
    List<OrderDetailItemDB> sortedList = List.from(items);
    sortedList.sort((a, b) => (a.lineNr ?? 0).compareTo(b.lineNr ?? 0));
    return sortedList;
  }

  void _getLocalOrderDetailItemList() async {
    var results = await _dbHelper.getOrderDetailItemList(widget.item.orderId!);
    isPriceVisible = await ServiceSharedPreferences.getSharedBool(SharedPreferencesKey.isPriceVisible) ?? false;
    orderDetailItemList = results;
    orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        width: double.infinity,
        color: Color(0xfffafafa),
        child: _body(),
      ),
    );
  }

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.ficheNo.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    //toplamaya devam et
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderScan(
                                      orderDetailItemList: orderDetailItemList,
                                      orderId: widget.item.orderId!,
                                    ))).then((value) async {
                          var results = await _dbHelper.getOrderDetailItemList(widget.item.orderId!);
                          orderDetailItemList = results;
                          orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
                          setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.access_time,
                        size: 30,
                        color: Color(0xffff9700),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Divider(
                color: Color.fromARGB(255, 235, 235, 235),
                thickness: 1.5,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            _infoRow("Tarih", DateFormat('dd-MM-yyyy').format(widget.item.ficheDate!)),
            _divider(),
            _infoRow("Müşteri", widget.item.customer.toString()),
            _divider(),
            _infoRow("Depolar", widget.item.warehouse.toString()),
            _divider(),
            _infoRow("Adet", widget.item.lineCount.toString()),
            _divider(),
            _infoRow("Tutar", isPriceVisible ? widget.item.total.toString() : "***"),
            _divider(),
            _infoRow("Durum", widget.item.orderStatus.toString()),
            _divider(),
            _infoRow("Operatör", widget.item.assingmetFullname.toString()),
            _divider(),
            const SizedBox(
              height: 25,
            ),
            _orderLineRow(),
            const SizedBox(
              height: 25,
            ),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: orderDetailItemList!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    color: const Color(0xfff1f1f1),
                    child: InkWell(
                      onLongPress: () {},
                      highlightColor: const Color.fromARGB(255, 179, 199, 211),
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(right: 15, left: 15),
                        leading: Text(
                          (index + 1 < 10)
                              ? "0${index + 1} ${serilotType(orderDetailItemList![index].serilotType!)}"
                              : "${index + 1} ${serilotType(orderDetailItemList![index].serilotType!)}",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                        ),
                        trailing: Text(
                          "${orderDetailItemList![index].scannedQty!} / ${orderDetailItemList![index].qty}",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: selectColor(
                                  orderDetailItemList![index].scannedQty!, orderDetailItemList![index].qty!)),
                        ),
                        title: Text(
                          "${orderDetailItemList![index].productBarcode}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff727272),
                          ),
                        ),
                        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "${orderDetailItemList![index].productName}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                          ),
                          Text(
                            "${orderDetailItemList![index].warehouse}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                          )
                        ]),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            _listTileButton("Toplamaya Devam Et", Icons.access_time, const Color.fromARGB(255, 228, 228, 228),
                const Color(0xffff9700), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderScan(
                            orderDetailItemList: orderDetailItemList,
                            orderId: widget.item.orderId!,
                          ))).then((value) async {
                var results = await _dbHelper.getOrderDetailItemList(widget.item.orderId!);
                orderDetailItemList = results;
                orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);

                setState(() {});
              });
            }),

            const SizedBox(
              height: 35,
            ),
            // _orderLog(),
            // SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "Sipariş Detayı",
        style: TextStyle(color: Colors.deepOrange[700], fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Padding _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 5),
      child: Divider(
        color: Color.fromARGB(255, 235, 235, 235),
        thickness: 0.5,
      ),
    );
  }

  Padding _infoRow(String infoTitle, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              infoTitle,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 73, 73, 73),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              info,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color.fromARGB(255, 92, 92, 92),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Padding _listTileButton(String content, IconData icon, Color textColor, Color backgroundColor, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Kenar yuvarlaklığını burada ayarlayabilirsiniz
        ),
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: ListTile(
            leading: Icon(
              icon,
              color: textColor,
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                content,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
      ),
    );
  }

  Row _orderLineRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Sipariş Satırları",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffe44817),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            widget.item.lineCount.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffe44817),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  String serilotType(int type) {
    if (type == 1) {
      return "N";
    } else if (type == 2) {
      return "S";
    } else if (type == 3) {
      return "L";
    } else {
      return "Z";
    }
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
