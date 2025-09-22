import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/locations/stock_location_barcode_response.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_counting_fiche_detail.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_counting_fiche_update_request.dart';
import 'package:gns_warehouse/models/product_barcode_detail_response.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_area.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_product_update.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_location.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/widgets/gns_app_bar.dart';
import 'package:gns_warehouse/widgets/gns_line_button.dart';
import 'package:gns_warehouse/widgets/gns_show_dialog.dart';

// ignore: must_be_immutable
class CountFicheScan extends StatefulWidget {
  CountFicheScan({
    super.key,
    required this.detailResponse,
    required this.stockCountingFicheList,
    required this.countFicheScannedLog,
    required this.onListChanged,
    required this.onLogListChanged,
    required this.onSaveButtonClicked,
  });

  List<StockCountingFicheItems> stockCountingFicheList;
  List<CountFicheScannedLog> countFicheScannedLog;
  final ValueChanged<List<StockCountingFicheItems>> onListChanged;
  final ValueChanged<List<CountFicheScannedLog>> onLogListChanged;
  final ValueChanged<String> onSaveButtonClicked;

  StockCountingFicheDetail detailResponse;
  @override
  State<CountFicheScan> createState() => _CountFicheScanState();
}

class _CountFicheScanState extends State<CountFicheScan> {
  bool isInfoAreaVisible = false;
  bool isInitCompleted = false;
  bool isClosedFromServer = false;
  bool isScanLocationVisible = true;
  bool isLatestScannedProductsVisible = true;
  late ApiRepository apiRepository;
  StockLocationBarcodeResponse? locationResponse;
  String selectedLocationId = "";
  String selectedLocationName = "";
  int scannedTimes = 1;
  List<StockCountingFicheItems> stockCountingFicheList = [];
  List<CountFicheScannedLog> countFicheScannedLog = [];
  String guidEmpty = "00000000-0000-0000-0000-000000000000";
  String creatingError = "count_fiche_scan sinifinda olusturuldu";

  @override
  void initState() {
    super.initState();
    _createApiRepository();
    isClosedFromServer =
        widget.detailResponse.stockCountingFiche?.isClosed ?? false;
    stockCountingFicheList = widget.stockCountingFicheList;
    countFicheScannedLog = widget.countFicheScannedLog;
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    setState(() {
      isInitCompleted = true;
    });
  }

  _addItemToExpectedItem(String barcode, String locationId) async {
    bool isAnyBarcodeMatch = false;
    stockCountingFicheList.forEach((element) {
      if (element.product?.barcode.toString() == barcode &&
          element.stockLocation?.stockLocationId.toString() == locationId) {
        isAnyBarcodeMatch = true;
        element.qty = element.qty! + scannedTimes;
        countFicheScannedLog.insert(
            0,
            CountFicheScannedLog(
                barcode: barcode,
                productName: element.product?.definition ?? "",
                selectedLocationName: selectedLocationName,
                qty: scannedTimes));
        setState(() {});
        return;
      }
      element.unit?.conversions?.forEach((conversion) {
        conversion.barcodes?.forEach((conversionBarcode) {
          if (conversionBarcode.barcode.toString() == barcode &&
              element.stockLocation?.stockLocationId.toString() == locationId) {
            isAnyBarcodeMatch = true;
            element.qty = element.qty! + conversion.convParam2! * scannedTimes;
            countFicheScannedLog.insert(
                0,
                CountFicheScannedLog(
                    barcode: barcode,
                    productName: element.product?.definition ?? "",
                    selectedLocationName: selectedLocationName,
                    qty: conversion.convParam2! * scannedTimes));
            setState(() {});
            return;
          }
        });
      });
    });

    if (!isAnyBarcodeMatch) {
      try {
        var productResponse =
            await apiRepository.getProductBasedOnBarcode(barcode);
        StockCountingFicheItems newItem =
            _createStockCountingFicheItem(productResponse);
        stockCountingFicheList.add(newItem);
        isAnyBarcodeMatch = true;
        countFicheScannedLog.insert(
            0,
            CountFicheScannedLog(
                barcode: barcode,
                productName: newItem.product?.definition ?? "",
                selectedLocationName: selectedLocationName,
                qty: productResponse.data?.unitConversion?.convParam2 ?? 1));
        setState(() {});
        return;
      } catch (e) {
        // ignore: use_build_context_synchronously
        GNSShowDialog(
            context,
            "BULUNAMADI !",
            "Girilen barkod ile eşleşen bir barkod bulunamadı.",
            "Kapat",
            "Tamam",
            () => Navigator.of(context).pop());

        return;
      }
    }

    if (!isAnyBarcodeMatch) {
      // ignore: use_build_context_synchronously
      GNSShowDialog(
          context,
          "BULUNAMADI !",
          "Girilen barkod ile eşleşen bir barkod bulunamadı.",
          "Kapat",
          "Tamam",
          () => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop && stockCountingFicheList.isNotEmpty) {
          widget.onListChanged(stockCountingFicheList);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GnsAppBar("Stok Sayım Fişi Okutma", context),
        body: isInitCompleted
            ? Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Column(
                  children: [
                    //appbar
                    // CountFicheInfoArea(),
                    // SizedBox(
                    //   height: isScanLocationVisible ? 5 : 0,
                    // ),
                    //lokasyon seçme alanı
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: isScanLocationVisible ? 50 : 0,
                      child: SingleChildScrollView(
                        child: CountFicheScanLocation(
                          onBarcodeChanged: (val) async {
                            try {
                              _showLoadingScreen(true, "Aranıyor");
                              locationResponse = await apiRepository
                                  .getStockLocationBasedOnBarcode(
                                      val.toString());
                              selectedLocationId = locationResponse
                                      ?.stockLocation?.stockLocationId ??
                                  "";
                              selectedLocationName =
                                  locationResponse?.stockLocation?.name ?? "";
                              _showLoadingScreen(false, "Aranıyor");
                              setState(() {});
                            } catch (e) {
                              _showLoadingScreen(false, "Aranıyor");
                              // ignore: use_build_context_synchronously
                              GNSShowDialog(
                                  context,
                                  "BULUNAMADI !",
                                  "Bu barkodla eşleşen bir lokasyon bulunamadı. \n ${e.toString()}",
                                  "Kapat",
                                  "Tamam",
                                  () => Navigator.of(context).pop());
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _selectedLocationInfo(),
                    const SizedBox(
                      height: 5,
                    ),
                    //ürün okutulan alan
                    CountFicheScanArea(
                      onBarcodeChanged: (val) async {
                        if (locationResponse != null) {
                          await _addItemToExpectedItem(
                              val.toString(), selectedLocationId);
                        } else {
                          GNSShowDialog(
                              context,
                              "HATA !",
                              "Lokasyon seçmeden ürün okutması yapamazsınız ! \nÖnce lokasyonun barkodunu yukarıdaki alanda okutmalısınız.",
                              "Kapat",
                              "Tamam",
                              () => Navigator.of(context).pop());
                        }
                      },
                      seriOrBarcode: (val) {},
                      scannedTimes: (val) {
                        scannedTimes = val!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _showLatestScannedProductButton(),
                    AnimatedContainer(
                      height: isLatestScannedProductsVisible ? 120 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: ListView.builder(
                        itemCount: countFicheScannedLog.length,
                        itemBuilder: (context, index) {
                          return _scannedBarcodeLogItem(
                              countFicheScannedLog[index]);
                        },
                      ),
                    ),
                    // Expanded(
                    //   flex: isLatestScannedProductsVisible ? 3 : 0,
                    //   child: AnimatedContainer(
                    //     height: isLatestScannedProductsVisible ? null : 0,
                    //     duration: const Duration(milliseconds: 200),
                    //     child: ListView.builder(
                    //       itemCount: countFicheScannedLog.length,
                    //       itemBuilder: (context, index) {
                    //         return _scannedBarcodeLogItem(
                    //             countFicheScannedLog[index]);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Expanded(
                    //   flex: 3,
                    //   child: ListView.builder(
                    //     itemCount: countFicheScannedLog.length,
                    //     itemBuilder: (context, index) {
                    //       return _scannedBarcodeLogItem(
                    //           countFicheScannedLog[index]);
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        flex: 8,
                        child: ListView(
                          children: List.generate(stockCountingFicheList.length,
                              (index) {
                            return _itemCard(
                                stockCountingFicheList[index], index);
                          }),
                        )),
                    // Expanded(
                    //   flex: 8,
                    //   child: ListView.builder(
                    //       itemCount: 100,
                    //       itemBuilder: (context, index) {
                    //         print("oluşturuldu $index");
                    //         return const CountFicheItemRow();
                    //       }),
                    // ),
                    GnsLineButton(
                      "Kaydet",
                      Icons.save_alt_rounded,
                      Colors.black,
                      Colors.orange,
                      () async {
                        GNSShowDialog(
                            context,
                            "EMİN MİSİNİZ ?",
                            "Sayım fişini kaydetmek istediğinize emin misiniz ?",
                            "Hayır",
                            "Evet",
                            () => _writeDataToServer(isClosedFromServer));
                      },
                    ),
                    GnsLineButton(
                      "Kaydet Ve Stok Sayımını Sonlandır",
                      Icons.lock,
                      Colors.black,
                      Colors.deepOrange,
                      () async {
                        GNSShowDialog(
                            context,
                            "EMİN MİSİNİZ ?",
                            "Sayım fişini kaydetmek ve kapatmak istediğinize emin misiniz ?",
                            "Hayır",
                            "Evet",
                            () => _writeDataToServer(true));
                      },
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> _writeDataToServer(bool isClosed) async {
    try {
      _showLoadingScreen(true, "Güncelleme Yapılıyor");
      await apiRepository
          .updateStockCountingFiche(_createBodyForUpdate(isClosed));
      stockCountingFicheList = [];
      countFicheScannedLog = [];
      widget.onSaveButtonClicked("");
      setState(() {});
      _showLoadingScreen(false, "Güncelleme Yapılıyor");
      //GNS SHOW DIALOG KAPATILMASI İÇİN
      Navigator.of(context).pop();
      //SCAN PAGE'DEN ÇIKMAK İÇİN
      Navigator.of(context).pop();
    } catch (e) {
      _showLoadingScreen(false, "Güncelleme Yapılıyor");
      //GNS SHOW DIALOG KAPATILMASI İÇİN
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      GNSShowDialog(
          context,
          "BAŞARISIZ !",
          "Güncelleme başarısız oldu. \n${e.toString()}",
          "Kapat",
          "Tamam",
          () => Navigator.of(context).pop());
    }
  }

  Card _itemCard(StockCountingFicheItems item, int index) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 233, 233, 233),
      child: InkWell(
        onLongPress: () {
          _showDialogForUpdateProduct(context, "Güncelle", item, index);
        },
        highlightColor: const Color.fromARGB(255, 179, 199, 211),
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          contentPadding: const EdgeInsets.only(right: 15, left: 15),
          leading: Text(
            index + 1 <= 9 ? "0${index + 1}" : "${index + 1}",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 32, 32, 32),
            ),
          ),
          trailing: Text(
            item.qty!.toInt().toString(),
            style: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          title: Text(
            item.product!.barcode.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff727272),
            ),
          ),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              item.product!.definition.toString(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700]),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
                children: <TextSpan>[
                  const TextSpan(
                    text: "Lokasyon : ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "${item.stockLocation!.name} | ${item.stockLocation!.barcode}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  InkWell _selectedLocationInfo() {
    return InkWell(
      onTap: () {
        isScanLocationVisible = !isScanLocationVisible;
        setState(() {});
      },
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      splashColor: const Color.fromARGB(255, 255, 230, 223),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
            children: <TextSpan>[
              const TextSpan(
                text: "Lokasyon : ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: locationResponse == null
                    ? "Seçilmedi"
                    : "${locationResponse?.stockLocation?.name.toString()} | ${locationResponse?.stockLocation?.barcode.toString()}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _showLatestScannedProductButton() {
    return InkWell(
      onTap: () {
        isLatestScannedProductsVisible = !isLatestScannedProductsVisible;
        setState(() {});
      },
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      splashColor: const Color.fromARGB(255, 255, 230, 223),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
            children: <TextSpan>[
              TextSpan(
                text: isLatestScannedProductsVisible
                    ? "Son Okutulanları Gizle"
                    : "Son Okutulanları Göster",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _scannedBarcodeLogItem(CountFicheScannedLog logItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //barkod ve lokasyon
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logItem.barcode,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          logItem.selectedLocationName,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              //malzeme adı
              Expanded(
                flex: 6,
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          logItem.productName.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              //qty
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          logItem.qty.toString(),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _divider(),
        ],
      ),
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

  Padding _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 0),
      child: Divider(
        color: Color.fromARGB(255, 235, 235, 235),
        thickness: 0.5,
      ),
    );
  }

  StockCountingFicheItems _createStockCountingFicheItem(
      ProductBarcodeDetailResponse productResponse) {
    return StockCountingFicheItems(
        stockCountingFicheItemId: guidEmpty,
        lineNr: 1,
        description: "",
        qty: productResponse.data?.unitConversion?.convParam2?.toDouble() ?? 1,
        unitId: productResponse.data?.unit?.unitId ?? guidEmpty,
        unitName: productResponse.data?.unit?.description ?? creatingError,
        unitConversionId: productResponse
                .data?.product?.unit?.conversions?[0].unitConversionId ??
            guidEmpty,
        unitConversionName:
            productResponse.data?.product?.unit?.conversions?[0].description ??
                creatingError,
        unit: Unit.fromJson(productResponse.data!.product!.unit!.toJson()),
        stockLocation: StockLocation(
          stockLocationId:
              locationResponse?.stockLocation?.stockLocationId ?? guidEmpty,
          code: locationResponse?.stockLocation?.code ?? creatingError,
          name: locationResponse?.stockLocation?.name ?? creatingError,
          barcode: locationResponse?.stockLocation?.barcode ?? creatingError,
        ),
        erpId: "",
        erpCode: "",
        product: Product(
          productId: productResponse.data?.product?.productId ?? guidEmpty,
          code: productResponse.data?.product?.code ?? creatingError,
          definition:
              productResponse.data?.product?.definition ?? creatingError,
          definition2:
              productResponse.data?.product?.definition2 ?? creatingError,
          barcode: productResponse.data?.product?.barcode ?? creatingError,
          productTrackingMethod:
              productResponse.data?.product?.productTrackingMethod ??
                  creatingError,
          productItemTypeId:
              productResponse.data?.product?.productItemTypeId ?? 0,
          productItemTypeName: creatingError,
        ));
  }

  StockCountingFicheUpdateRequest _createBodyForUpdate(bool isClosed) {
    return StockCountingFicheUpdateRequest(
      stockCountingFicheId:
          widget.detailResponse.stockCountingFiche?.stockCountingFicheId ??
              guidEmpty,
      ficheNo: widget.detailResponse.stockCountingFiche?.ficheNo ?? "",
      ficheDate: widget.detailResponse.stockCountingFiche?.ficheDate ?? "",
      countingStartDate:
          widget.detailResponse.stockCountingFiche?.countingStartDate ?? "",
      description: widget.detailResponse.stockCountingFiche?.description ?? "",
      stockCountingTeamId: widget.detailResponse.stockCountingFiche
              ?.stockCountingTeam?.stockCountingTeamId ??
          guidEmpty,
      warehouseId:
          widget.detailResponse.stockCountingFiche?.warehouse?.warehouseId ??
              guidEmpty,
      isClosed: isClosed,
      stockcountingficheitems: _createStockCountingItemList(),
    );
  }

  List<Stockcountingficheitems> _createStockCountingItemList() {
    List<Stockcountingficheitems> list = [];

    stockCountingFicheList.forEach((element) {
      Stockcountingficheitems item = Stockcountingficheitems(
        stockCountingFicheItemId: element.stockCountingFicheItemId,
        productId: element.product!.productId,
        productItemType: element.product!.productItemTypeId,
        description: element.description,
        qty: element.qty!.toInt(),
        warehouseId:
            widget.detailResponse.stockCountingFiche!.warehouse!.warehouseId,
        unitId: element.unitId,
        unitConversionId: element.unitConversionId,
        stockLocationId: element.stockLocation!.stockLocationId,
        erpId: element.erpId,
        erpCode: element.erpCode,
      );

      list.add(item);
    });
    return list;
  }

  Future<dynamic> _showDialogForUpdateProduct(BuildContext context,
      String content, StockCountingFicheItems oldItem, int index) {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: true,
        child: Container(
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
              ),
              // title: Text(content),
              contentPadding: const EdgeInsets.all(10.0),
              content: TabbedCountFicheUpdateProduct(
                oldItem: oldItem,
                onValueChanged: (value) {
                  stockCountingFicheList[index] = value;
                  setState(() {});
                },
              )),
        ),
      ),
    );
  }
}

class CountFicheScannedLog {
  String barcode;
  String productName;
  String selectedLocationName;
  int qty;

  CountFicheScannedLog({
    required this.barcode,
    required this.productName,
    required this.selectedLocationName,
    required this.qty,
  });
}
