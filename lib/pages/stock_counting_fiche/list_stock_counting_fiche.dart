import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_couting_fiche_list_response.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/count_fiche_detail.dart';
import 'package:gns_warehouse/pages/transfer_fiche/create_transfer_fiche.dart';

import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:intl/intl.dart';

class StockCountingFicheList extends StatefulWidget {
  const StockCountingFicheList({super.key});

  @override
  State<StockCountingFicheList> createState() => _StockCountingFicheListState();
}

class _StockCountingFicheListState extends State<StockCountingFicheList> {
  late ApiRepository apiRepository;
  late TextEditingController _searchController;
  late StockCountingFicheListResponse? listResponse;
  int transferFichePage = 1;
  List<StockCountingItems> listItems = [];
  String query = "";
  bool isFetched = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    listResponse = await apiRepository.getStockCountingFicheList(1, "");
    listItems = listResponse?.stockCountingFiches?.items ?? [];
    setState(() {
      isFetched = true;
    });
  }

  void _filterOrderUsingService(String newQuery) async {
    transferFichePage++;
    setState(() {
      isLoading = true;
    });
    var newResponse = await apiRepository.getStockCountingFicheList(
        transferFichePage, newQuery);
    listItems = listItems + newResponse!.stockCountingFiches!.items!;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isFetched
          ? Container(
              child: Column(
                children: [
                  _searchBar(),
                  const SizedBox(
                    height: 10,
                  ),
                  // _createWarehouseTransferButton(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                top: 0, right: 8, bottom: 0, left: 8),
                            itemCount: listItems.length,
                            itemBuilder: (context, index) {
                              return _row(listItems[index]);
                            },
                          ),
                          listItems.isNotEmpty
                              ? _addMoreDataButton()
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  TextButton _addMoreDataButton() {
    return TextButton(
      onPressed: () {
        _filterOrderUsingService(query);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        'Daha Fazla Yükle',
        style: TextStyle(
            color: Colors.deepOrange, // Metin rengi
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container _searchBar() {
    return Container(
        color: Color.fromARGB(255, 255, 240, 152),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                query = value;
                transferFichePage = 0;
                listItems = [];
                _filterOrderUsingService(value);
              },
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    splashColor: const Color.fromARGB(255, 255, 223, 187),
                    onTap: () {
                      query = _searchController.text;
                      transferFichePage = 0;
                      listItems = [];
                      _filterOrderUsingService(_searchController.text);
                    },
                    child: Container(
                      child: const Center(
                          child: Text(
                        "ARA",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Padding _createWarehouseTransferButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.orangeAccent,
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: const Color.fromARGB(255, 255, 223, 187),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CreateTransferFichePage()))
                    .then((value) async {
                  setState(() {
                    isFetched = false;
                  });
                  listResponse =
                      await apiRepository.getStockCountingFicheList(1, "");
                  listItems = listResponse?.stockCountingFiches?.items ?? [];

                  setState(() {
                    isFetched = true;
                  });
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Stok Sayım Fişi Oluştur",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Padding _row(StockCountingItems item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6),
          minVerticalPadding: 1,
          leading: const Padding(
            padding: EdgeInsets.only(left: 3),
            child: VerticalDivider(thickness: 4, color: Colors.blue),
          ),
          title: Text(
            "#${item.ficheNo}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "${item.warehouse?.definition.toString()}",
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              //   style:
              //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              // ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Depo : ",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "${item.warehouse?.definition.toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    const TextSpan(
                      text: "     Sorumlu : ",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            '${item.stockCountingTeam?.name} ${item.stockCountingTeam?.surName}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Yardımcılar : ",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: _truncateText(
                          item.stockCountingTeam?.otherTeamMembers ?? "", 50),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 46, 46, 46),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            'Tarih: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.ficheDate!))}  Saat: ${DateFormat('HH:mm:ss').format(DateTime.parse(item.ficheDate!))}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          trailing: Text(
            item.isClosed! ? "Kapandı" : "Kapanmadı",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          //isThreeLine: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CountFicheDetail(
                  ficheId: item.stockCountingFicheId.toString(),
                ),
              ),
            ).then((value) async {});
          },
          onLongPress: () {},
          dense: true,
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: isLoading
          ? const CircularProgressIndicator()
          : Text(
              "Stok Sayım Fiş Listesi",
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

  String _truncateText(String text, int limit) {
    if (text.length > limit) {
      return '${text.substring(0, limit)}...'; // Belirtilen sınırdan sonrasını kesip "..." ekler
    }
    return text; // Sınırı aşmazsa orijinal metni döndürür
  }
}
