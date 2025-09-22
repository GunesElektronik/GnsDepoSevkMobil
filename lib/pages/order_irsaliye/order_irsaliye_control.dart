import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';
import 'package:gns_warehouse/pages/order_irsaliye/order_irsaliye_list.dart';
import 'package:gns_warehouse/pages/purchase_orders/order_control_card.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_list.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:intl/intl.dart';
/*
class IrsaliyeOrderControl extends StatefulWidget {
  const IrsaliyeOrderControl({super.key});

  @override
  State<IrsaliyeOrderControl> createState() => _IrsaliyeOrderControlState();
}

class _IrsaliyeOrderControlState extends State<IrsaliyeOrderControl> {
  late ApiRepository apiRepository;
  bool deneme = false;
  bool isCreateApiRepo = false;
  DateTime? picked = DateTime.now();
  String customerName = "";
  NewCustomerListResponse? response;
  List<PurchaseOrderSummaryItem>? purchaseResponse;
  PurchaseOrderDetailResponse? detailResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createApiRepository();
  }

  Future<void> createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    await getCustomerList();
    setState(() {
      isCreateApiRepo = true;
    });
  }

  Future<void> getCustomerList() async {
    response = await apiRepository.getCustomer();
    // purchaseResponse = await apiRepository.getPurchaseOrderSummaryList();
    // detailResponse = await apiRepository
    //    .getPurchaseOrderDetail("4b1495cc-5daa-45f5-b6cd-7b976b41dbf2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: isCreateApiRepo
          ? PopScope(
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
                          "IRS00000123 -Var - Sevkedilebilir",
                          DateFormat('dd.MM.yyyy').format(picked!),
                          Icons.date_range_rounded, () {
                        _showDate(context);
                      }),
                      _divider(),
                      _listTile(
                          "120.08.0001", customerName, Icons.store_outlined,
                          () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              _productLogBottomSheet(response!),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: _button("Satın Alma Siparişlerini Bul",
                            Colors.white, const Color(0xff8a9c9c), () {}),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return const OrderControlCard();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _button("Toplama Listesini Kaydet", Colors.white,
                            const Color(0xffff9700), () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: _button("Toplama Listesine Git", Colors.white,
                            const Color(0xffff9700), () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const IrsaliyeOrderList(),
                          ));
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<DateTime?> _showDate(BuildContext context) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    setState(() {});
  }

  ListTile _listTile(
      String title, String subtitle, IconData iconData, Function()? onPressed) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 0),
      trailing: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 30,
            color: Colors.deepOrange,
          ),
        ),
      ),
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
          _headerText("Kontrol", Colors.deepOrange),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 25,
            color: Color(0xffd5d5d5),
          ),
          _headerText("Liste", const Color(0xff919b9a)),
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

  Divider _divider() {
    return const Divider(
      color: Color.fromARGB(255, 228, 228, 228),
      thickness: 1,
    );
  }

  _showLoadingScreen(bool isLoading, String content) {
    if (isLoading) {
      return showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: content,
              ),
            );
          });
    } else {
      Navigator.pop(context); // Loading screen'i kapat
    }
  }

  Widget _productLogBottomSheet(NewCustomerListResponse response) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Müşteriler",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: response.customers!.items!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            child: InkWell(
                              splashColor: Colors.deepOrangeAccent,
                              onTap: () {
                                customerName = response
                                    .customers!.items![index].name
                                    .toString();
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: ListTile(
                                title: Text(
                                  response.customers!.items![index].name
                                      .toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/