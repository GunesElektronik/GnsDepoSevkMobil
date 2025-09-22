import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_counting_fiche_detail.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/count_fiche_scan.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/widgets/gns_app_bar.dart';
import 'package:gns_warehouse/widgets/gns_line_button.dart';
import 'package:gns_warehouse/widgets/gns_request_not_found.dart';
import 'package:gns_warehouse/widgets/gns_snackbar.dart';
import 'package:intl/intl.dart';

class CountFicheDetail extends StatefulWidget {
  const CountFicheDetail({
    super.key,
    required this.ficheId,
  });

  final String ficheId;

  @override
  State<CountFicheDetail> createState() => _CountFicheDetailState();
}

class _CountFicheDetailState extends State<CountFicheDetail> {
  bool isFetched = false;
  bool isThereException = false;
  bool isFicheClosed = false;
  String exceptionMessage = "";
  late ApiRepository apiRepository;

  List<StockCountingFicheItems> stockCountingFicheList = [];
  List<CountFicheScannedLog> countFicheScannedLog = [];

  StockCountingFicheDetail? detailResponse;

  @override
  void initState() {
    super.initState();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    try {
      detailResponse =
          await apiRepository.getStockCountingFicheDetail(widget.ficheId);
      stockCountingFicheList =
          detailResponse?.stockCountingFiche?.stockCountingFicheItems ?? [];
      isFicheClosed = detailResponse?.stockCountingFiche?.isClosed ?? false;
      isFetched = true;
    } catch (e) {
      exceptionMessage = e.toString();
      isThereException = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GnsAppBar("Stok Sayım Fişi Detay", context),
      body: isFetched
          ? _body(context)
          : isThereException
              ? requestNotFound(exceptionMessage)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }

  Container _body(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      //fiche no area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            detailResponse!.stockCountingFiche!.ficheNo ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      _divider(),
                      //detay bilgileri
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _infoRow(
                                  "Tarih",
                                  DateFormat('dd-MM-yyyy / HH:mm').format(
                                      DateTime.parse(detailResponse!
                                              .stockCountingFiche!.ficheDate ??
                                          "01-01-2000"))),
                              _divider(),
                              _infoRow(
                                  "Depolar",
                                  detailResponse!.stockCountingFiche!.warehouse!
                                          .definition ??
                                      ""),
                              _divider(),
                              _infoRow(
                                  "Açıklama",
                                  detailResponse!
                                      .stockCountingFiche!.description
                                      .toString()),
                              _divider(),
                              _infoRow("Sorumlu", _getNameAndSurname()),
                              _divider(),
                              _infoRow(
                                  "Yardımcılar",
                                  detailResponse!
                                          .stockCountingFiche!
                                          .stockCountingTeam!
                                          .otherTeamMembers ??
                                      ""),
                              _divider(),
                              _infoRow(
                                  "Durum",
                                  detailResponse!.stockCountingFiche!.isClosed!
                                      ? "Kapandı"
                                      : "Kapanmadı"),
                              _divider(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              height: 0,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.only(top: 0, right: 8, bottom: 0, left: 8),
                itemCount: stockCountingFicheList.length,
                itemBuilder: (context, index) {
                  return _itemCard(stockCountingFicheList[index], index);
                },
              ),
            ),
          ),
          //butonlar
          Column(
            children: [
              !isFicheClosed
                  ? GnsLineButton("Sayım Yapmaya Devam Et",
                      Icons.warehouse_rounded, Colors.black, Colors.amber, () {
                      Navigator.of(context).push<String>(MaterialPageRoute(
                        builder: (context) => CountFicheScan(
                          detailResponse: detailResponse!,
                          stockCountingFicheList: stockCountingFicheList,
                          countFicheScannedLog: countFicheScannedLog,
                          onListChanged: (value) {
                            stockCountingFicheList = value;
                            setState(() {});
                          },
                          onLogListChanged: (value) =>
                              countFicheScannedLog = value,
                          onSaveButtonClicked: (value) async {
                            ShowSnackBar(context, "Sayım fişi kaydedildi.");
                            try {
                              detailResponse = await apiRepository
                                  .getStockCountingFicheDetail(widget.ficheId);
                              stockCountingFicheList = detailResponse
                                      ?.stockCountingFiche
                                      ?.stockCountingFicheItems ??
                                  [];
                              countFicheScannedLog = [];
                              isFetched = true;
                            } catch (e) {
                              exceptionMessage = e.toString();
                              isThereException = true;
                            }
                            setState(() {});
                          },
                        ),
                      ));
                    })
                  : const SizedBox(),
              // GnsLineButton(
              //   "Kaydet",
              //   Icons.save_alt_rounded,
              //   Colors.black,
              //   Colors.deepOrange,
              //   () {
              //     //kaydet
              //   },
              // ),
            ],
          )
        ],
      ),
    );
  }

  String _getNameAndSurname() {
    return "${detailResponse!.stockCountingFiche!.stockCountingTeam!.name} ${detailResponse!.stockCountingFiche!.stockCountingTeam!.surName}";
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

  Card _itemCard(StockCountingFicheItems item, int index) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 233, 233, 233),
      child: InkWell(
        onLongPress: () {},
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
}
