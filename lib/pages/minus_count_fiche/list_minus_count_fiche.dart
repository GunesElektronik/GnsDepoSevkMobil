import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/minus_count_fiche/minus_count_fiche_list_reponse.dart';
import 'package:gns_warehouse/pages/minus_count_fiche/create_minus_count_fiche.dart';
import 'package:gns_warehouse/pages/minus_count_fiche/detail_minus_count_fiche.dart';

import 'package:gns_warehouse/repositories/apirepository.dart';

class MinusCountFicheList extends StatefulWidget {
  const MinusCountFicheList({super.key});

  @override
  State<MinusCountFicheList> createState() => _MinusCountFicheListState();
}

class _MinusCountFicheListState extends State<MinusCountFicheList> {
  late ApiRepository apiRepository;
  late TextEditingController _searchController;
  late MinusCountFicheListResponse? ficheListResponse;
  int fichePage = 1;
  List<MinusCountFicheItems> minusCountFicheItems = [];
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
    ficheListResponse = await apiRepository.getMinusCountFicheList(1, "");
    minusCountFicheItems = ficheListResponse?.minusCountFiches?.items ?? [];
    setState(() {
      isFetched = true;
    });
  }

  void _filterOrderUsingService(String newQuery) async {
    fichePage++;
    setState(() {
      isLoading = true;
    });
    var newResponse =
        await apiRepository.getMinusCountFicheList(fichePage, newQuery);
    minusCountFicheItems =
        minusCountFicheItems + newResponse!.minusCountFiches!.items!;

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
                  _createWarehouseTransferButton(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 0, right: 8, bottom: 0, left: 8),
                        itemCount: minusCountFicheItems.length,
                        itemBuilder: (context, index) {
                          return _row(minusCountFicheItems[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
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
                fichePage = 0;
                minusCountFicheItems = [];
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
                      fichePage = 0;
                      minusCountFicheItems = [];
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
                                const CreateMinusCountFichePage()))
                    .then((value) async {
                  setState(() {
                    isFetched = false;
                  });
                  ficheListResponse =
                      await apiRepository.getMinusCountFicheList(1, "");
                  minusCountFicheItems =
                      ficheListResponse?.minusCountFiches?.items ?? [];

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
                        "Sayım Eksiği Fişi Oluştur",
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

  Padding _row(MinusCountFicheItems item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6),
          minVerticalPadding: 1,
          leading: Container(
            width: 60,
            height: 78,
            alignment: Alignment.center,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Text(
                    item.customer == null ? "" : item.customer!.name.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          title: Text(
            "#${item.ficheNo}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.inWarehouse?.definition.toString()}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              // RichText(
              //   text: TextSpan(
              //     style: const TextStyle(fontSize: 10, color: Colors.black),
              //     children: <TextSpan>[
              //       const TextSpan(
              //           text: 'Ürün Sayısı: ',
              //           style: TextStyle(
              //               fontSize: 13, fontWeight: FontWeight.bold)),
              //       TextSpan(
              //           text: '${item.ficheTime}',
              //           style: const TextStyle(
              //             fontSize: 13,
              //           )),
              //     ],
              //   ),
              // ),
            ],
          ),
          trailing: const Icon(
            Icons.supervised_user_circle_outlined,
            color: Colors.black45,
            size: 24,
          ),
          //isThreeLine: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MinusCountFicheDetail(
                          minusCountFicheId: item.minusCountFicheId.toString(),
                        ))).then((value) async {});
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
              "Sayım Eksiği Fiş Listesi",
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
