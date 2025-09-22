import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/models/order_summary.dart';
import 'package:gns_warehouse/pages/scanqr.dart';
import 'package:gns_warehouse/widgets/gns_drawer_menu.dart';

import '../database/dbhelper.dart';
import '../repositories/apirepository.dart';
import '../services/sharedpreferences.dart';
import '../widgets/bottom_widget.dart';
import '../widgets/drawer_menu.dart';

class Synchronize extends StatefulWidget {
  const Synchronize({super.key});

  @override
  State<Synchronize> createState() => _SynchronizeState();
}

class _SynchronizeState extends State<Synchronize> {
  final DbHelper _dbHelper = DbHelper.instance;
  late ApiRepository apiRepository;
  String employeeName = "";
  String orderUpdateDate = "-";
  String purchaseOrderUpdateDate = "-";
  int orderListLocalCount = 0;
  int purchaseOrderListLocalCount = 0;
  String orderListServiceCount = "0";
  String purchaseOrderListServiceCount = "0";

  String resultMessage = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getParameter();
  }

  void getParameter() async {
    apiRepository = await ApiRepository.create(context);
    employeeName =
        await ServiceSharedPreferences.getSharedString("EmployeeName") ?? "";
    orderUpdateDate =
        await ServiceSharedPreferences.getSharedString("UpdateDate") ?? "-";

    purchaseOrderUpdateDate = await ServiceSharedPreferences.getSharedString(
            SharedPreferencesKey().purchaseOrderUpdateDate) ??
        "-";

    orderListServiceCount = await apiRepository.getOrderSummaryCount();
    purchaseOrderListServiceCount =
        await apiRepository.getPurchaseOrderSummaryCount();

    orderListLocalCount = await _dbHelper.getOrderHeaderCount();
    purchaseOrderListLocalCount =
        await _dbHelper.getPurchaseOrderSummaryCount();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: drawerMenu(context, employeeName),
      drawer: GNSDrawerMenu(
        employeeName: employeeName,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.deepOrange[700], size: 32 //change your color here
            ),
        title: Text(
          'Sipariş Güncelleme',
          style: TextStyle(
              color: Colors.deepOrange[700],
              fontWeight: FontWeight.bold,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 35,
                color: Colors.deepOrange[700],
              ))
        ],
      ),
      /*
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pop(context);
            Navigator.of(context).push<String>(MaterialPageRoute(
              builder: (context) => const ScanQr(),
            ));
          },
          backgroundColor: Colors.orange,
          elevation: 4,
          child: const Icon(
            Icons.qr_code_2_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        */
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: isLoading == true
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          resultMessage,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
              _updateInfoRow(
                  orderUpdateDate,
                  orderListLocalCount.toString(),
                  orderListServiceCount,
                  "Satış Siparişlerini Getir",
                  getOrderList),
              _updateInfoRow(
                  purchaseOrderUpdateDate,
                  purchaseOrderListLocalCount.toString(),
                  purchaseOrderListServiceCount,
                  "Satın Alma Siparişlerini Getir",
                  getPurchaseOrderList),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await getOrderList();
                  await getPurchaseOrderList();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Bütün Siparişleri Güncelle",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0XFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar: bottomWidget(context)
    );
  }

  Padding _updateInfoRow(String date, String localCount, String serviceCount,
      String buttonText, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$localCount / $serviceCount',
                    style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(buttonText,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0XFFFFFFFF))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getOrderList() async {
    setState(() {
      isLoading = true;
    });

    await apiRepository.getOrderSummaryList();
    apiRepository.getOrderSummaryCount().then((fetchedData) async {
      orderUpdateDate =
          await ServiceSharedPreferences.getSharedString("UpdateDate") ?? "-";
      print(orderUpdateDate);
      orderListLocalCount = await _dbHelper.getOrderHeaderCount();
      setState(() {
        orderListServiceCount = fetchedData.toString();
        resultMessage = "Güncelleme Tamamlandı.";
        isLoading = false;
      });
    });
  }

  Future<void> getPurchaseOrderList() async {
    setState(() {
      isLoading = true;
    });

    await apiRepository.getPurchaseOrderSummaryList();
    apiRepository.getPurchaseOrderSummaryCount().then((fetchedData) async {
      purchaseOrderUpdateDate = await ServiceSharedPreferences.getSharedString(
              SharedPreferencesKey().purchaseOrderUpdateDate) ??
          "-";

      purchaseOrderListLocalCount =
          await _dbHelper.getPurchaseOrderSummaryCount();
      setState(() {
        purchaseOrderListServiceCount = fetchedData.toString();
        resultMessage = "Güncelleme Tamamlandı.";
        isLoading = false;
      });
    });
  }

  Column _eskiUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 60,
          child: Center(
            child: isLoading == true
                ? Center(child: CircularProgressIndicator())
                : Text(
                    resultMessage,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
        const Center(
          child: Text(
            'Güncelleme Tarihi',
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
        Center(
          child: Text(
            '$orderUpdateDate',
            style: const TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Kayıtlı Sipariş Bilgisi Sayısı',
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
        Center(
          child: Text(
            orderListLocalCount.toString(),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Sunucudaki Sipariş Bilgisi Sayısı',
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
        Center(
          child: Text(
            '$orderListServiceCount',
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
//headerDataCount = await apiRepository.getOrderSummaryCount();
/*
                    FutureBuilder<List<OrderSummary>?>(
                      future: apiRepository
                          .getOrderSummaryList(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<List<OrderSummary>?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasData) {
                          setState(() {
                            headerCount = snapshot.data?.length ?? 0;
                          });
                        } else if (snapshot.hasError) {
                        } else {}
                        return const Text('Başarılı');
                      },
                    );
                    */
                  await apiRepository.getOrderSummaryList();
                  apiRepository
                      .getOrderSummaryCount()
                      .then((fetchedData) async {
                    orderUpdateDate =
                        await ServiceSharedPreferences.getSharedString(
                                "UpdateDate") ??
                            "-";
                    print(orderUpdateDate);
                    orderListLocalCount = await _dbHelper.getOrderHeaderCount();
                    setState(() {
                      orderListServiceCount = fetchedData.toString();
                      resultMessage = "Güncelleme Tamamlandı.";
                      isLoading = false;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.deepOrange),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text("Tüm Siparişleri Getir",
                      style: TextStyle(fontSize: 16, color: Color(0XFFFFFFFF))),
                ),
              ),
            ),
          ),
        ),
        _updateInfoRow(orderUpdateDate, orderListLocalCount.toString(),
            orderListServiceCount, "Satış Siparişlerini Getir", getOrderList),
      ],
    );
  }
}
