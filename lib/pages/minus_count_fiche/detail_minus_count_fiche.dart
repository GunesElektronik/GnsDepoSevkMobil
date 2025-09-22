import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/minus_count_fiche/minus_count_fiche_detail_response.dart';

import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MinusCountFicheDetail extends StatefulWidget {
  MinusCountFicheDetail({super.key, required this.minusCountFicheId});
  String minusCountFicheId;
  @override
  State<MinusCountFicheDetail> createState() => _MinusCountFicheDetailState();
}

class _MinusCountFicheDetailState extends State<MinusCountFicheDetail> {
  late ApiRepository apiRepository;
  bool isFetched = false;
  late MinusCountFicheDetailResponse detailResponse;
  late List<MinusCountFicheItems> minusCountFicheItemList;

  @override
  void initState() {
    super.initState();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    detailResponse =
        await apiRepository.getMinusCountFicheDetail(widget.minusCountFicheId);
    minusCountFicheItemList =
        detailResponse.minusCountFiche?.minusCountFicheItems ?? [];
    setState(() {
      isFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        width: double.infinity,
        color: const Color(0xfffafafa),
        child: isFetched ? _body() : _initLoading(),
      ),
    );
  }

  Center _initLoading() {
    return Center(
      child: CircularProgressIndicator(),
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
                  detailResponse.minusCountFiche?.ficheNo ?? "",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
            _infoRow(
                "Müşteri",
                detailResponse.minusCountFiche?.customer?.name.toString() ??
                    ""),
            _divider(),
            _infoRow(
                "Tarih",
                DateFormat('dd-MM-yyyy').format(DateTime.parse(
                    detailResponse.minusCountFiche?.ficheDate ??
                        "01-01-2000"))),

            _divider(),
            _infoRow("Proje",
                detailResponse.minusCountFiche?.project?.code.toString() ?? ""),
            _divider(),
            _infoRow("Adet", "5"),
            _divider(),

            _infoRow("Açıklama",
                detailResponse.minusCountFiche?.description.toString() ?? ""),
            _divider(),
            _inAndOutWorkplaceInfo(),
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
                itemCount: minusCountFicheItemList.length,
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
                          "${minusCountFicheItemList[index].qty!.toInt()}",
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                        title: Text(
                          "${minusCountFicheItemList[index].product!.barcode}",
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
                                "${minusCountFicheItemList[index].product!.definition}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700]),
                              ),
                              Text(
                                "${minusCountFicheItemList[index].inWarehouse!.definition}",
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

  IntrinsicHeight _inAndOutWorkplaceInfo() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Giriş",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ),
                _infoRowForWorkplace(
                    "İş Yeri",
                    detailResponse.minusCountFiche?.inWorkplace?.definition
                            .toString() ??
                        ""),
                _divider(),
                _infoRowForWorkplace(
                    "Departman",
                    detailResponse.minusCountFiche?.inDepartment?.definition
                            .toString() ??
                        ""),
                _divider(),
                _infoRowForWorkplace(
                    "Ambar",
                    detailResponse.minusCountFiche?.inWarehouse?.definition
                            .toString() ??
                        ""),
              ],
            ),
          ),
        ],
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

  Padding _infoRowForWorkplace(String infoTitle, String info) {
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
                fontSize: 12,
                color: Color.fromARGB(255, 73, 73, 73),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              //maxLines: 1,
              //overflow: TextOverflow.ellipsis,
              info,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
            detailResponse.minusCountFiche?.inWarehouse?.definition
                    .toString() ??
                "",
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
        "Sayım Eksiği Fişi Detayı",
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
