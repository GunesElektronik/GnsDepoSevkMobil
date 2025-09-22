import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/models/new_api/waybill_purchase_order_detail_response.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:intl/intl.dart';

class WaybillPurchaseOrderDetail extends StatefulWidget {
  WaybillPurchaseOrderDetail(
      {super.key,
      required this.waybillId,
      required this.erpSendMessage,
      required this.erpColor});

  String waybillId;
  String erpSendMessage;
  Color erpColor;
  @override
  State<WaybillPurchaseOrderDetail> createState() =>
      _WaybillPurchaseOrderDetailState();
}

class _WaybillPurchaseOrderDetailState
    extends State<WaybillPurchaseOrderDetail> {
  String productId = "";
  late ApiRepository apiRepository;
  late WaybillPurchaseOrderDetailResponse? waybillPurchaseOrderDetailResponse;
  bool isFetched = false;
  bool isSuccess = false;
  bool isPriceVisible = false;

  @override
  void initState() {
    super.initState();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    isPriceVisible = await ServiceSharedPreferences.getSharedBool(
            SharedPreferencesKey.isPriceVisible) ??
        false;
    try {
      waybillPurchaseOrderDetailResponse =
          await apiRepository.getWaybillPurchaseOrderDetail(widget.waybillId);

      setState(() {
        isFetched = true;
        isSuccess = true;
      });
    } catch (e) {
      setState(() {
        isFetched = true;
        isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isFetched
          ? Container(
              width: double.infinity,
              color: const Color(0xfffafafa),
              child: isSuccess ? _body() : _notFoundError(),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Container _notFoundError() {
    return Container(
      color: Colors.deepOrange,
      height: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: Colors.white),
              child: const Center(
                  child: Text(
                "İRSALİYE \n BULUNAMADI \n !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ),
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
                  waybillPurchaseOrderDetailResponse!.waybill!.ficheNo ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
            Container(
              color: widget.erpColor,
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "ERP MESAJI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.erpSendMessage,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 92, 92, 92),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _divider(),
            _infoRow(
                "Tarih",
                DateFormat('dd-MM-yyyy').format(DateTime.parse(
                    waybillPurchaseOrderDetailResponse!.waybill!.createdDate ??
                        "01-01-2000"))),
            _divider(),
            _infoRow(
                "Müşteri",
                waybillPurchaseOrderDetailResponse!.waybill!.customer!.name
                    .toString()),
            _divider(),
            _infoRow(
                "Depolar",
                waybillPurchaseOrderDetailResponse!.waybill!.warehouse!.code
                    .toString()),
            _divider(),
            _infoRow(
                "Adet",
                waybillPurchaseOrderDetailResponse!
                    .waybill!.waybillItems!.length
                    .toString()),
            _divider(),
            _infoRow(
                "Tutar",
                isPriceVisible
                    ? waybillPurchaseOrderDetailResponse!.waybill!.grossTotal
                        .toString()
                    : "***"),
            _divider(),
            _infoRow(
                "Durum",
                waybillPurchaseOrderDetailResponse!.waybill!.waybillStatusName
                    .toString()),
            _divider(),
            _infoRow(
                "Satışçı",
                waybillPurchaseOrderDetailResponse!.waybill!.salesman == null
                    ? ""
                    : waybillPurchaseOrderDetailResponse!
                        .waybill!.salesman!.name
                        .toString()),
            _divider(),
            _infoRow("Erp Mesajı", widget.erpSendMessage),
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
                itemCount: waybillPurchaseOrderDetailResponse!
                    .waybill!.waybillItems!.length,
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
                        contentPadding:
                            const EdgeInsets.only(right: 15, left: 15),
                        leading: Text(
                          (index + 1 < 10) ? "0${index + 1}" : "${index + 1}",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700]),
                        ),
                        trailing: Text(
                          "${waybillPurchaseOrderDetailResponse!.waybill!.waybillItems![index].qty!.toInt()}",
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                        title: Text(
                          "${waybillPurchaseOrderDetailResponse!.waybill!.waybillItems![index].product!.barcode}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff727272),
                          ),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${waybillPurchaseOrderDetailResponse!.waybill!.waybillItems![index].product!.code}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700]),
                              ),
                              Text(
                                "${waybillPurchaseOrderDetailResponse!.waybill!.waybillItems![index].warehouseName}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700]),
                              )
                            ]),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),

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
            waybillPurchaseOrderDetailResponse!.waybill!.waybillItems!.length
                .toString(),
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

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "İrsaliye Detayı",
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.bold,
            fontSize: 20),
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
}
