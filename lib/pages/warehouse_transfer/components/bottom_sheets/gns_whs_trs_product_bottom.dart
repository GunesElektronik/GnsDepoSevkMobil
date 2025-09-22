import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/transporter_list_response.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class GNSWhsTrsProductBottom extends StatefulWidget {
  const GNSWhsTrsProductBottom({super.key, required this.onValueChanged});
  final ValueChanged<ProductItems> onValueChanged;
  @override
  State<GNSWhsTrsProductBottom> createState() => _GNSWhsTrsProductBottomState();
}

class _GNSWhsTrsProductBottomState extends State<GNSWhsTrsProductBottom> {
  late ApiRepository apiRepository;
  TextEditingController _searchController = TextEditingController();
  List<ProductItems> filteredItems = [];
  late ProductItems? selectedItem;
  bool isFetched = false;
  bool isLoading = false;
  int productPage = 1;
  ProductListReponse? productResponse;
  String query = "";
  String productId = "";
  String productName = "Ürün";

  @override
  void initState() {
    super.initState();
    selectedItem = null;
    _createApiRepository();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    //customerResponse = await apiRepository.getCustomerDeneme(customerPage);
    //customerItems = customerResponse!.customers!.items!;
    productResponse =
        await apiRepository.getProductListSearch(productPage, query);
    filteredItems = productResponse!.products!.items!;
    setState(() {
      isFetched = true;
    });
  }

  void _filterUsingService(String query) async {
    productPage++;
    setState(() {
      isLoading = true;
    });

    var newResponse =
        await apiRepository.getProductListSearch(productPage, query);
    filteredItems = filteredItems + newResponse!.products!.items!;

    setState(() {
      isLoading = false;
    });
  }

  void _getMoreData() {
    // if (query != "") {
    //   _filterUsingService(query);
    // } else {
    //   _getNewCustomerItems();
    // }

    _filterUsingService(query);
  }

  @override
  Widget build(BuildContext context) {
    return isFetched
        ? Container(
            width: double.infinity,
            height: 600,
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          isLoading ? "Yükleniyor ..." : "Ürünler",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isLoading ? Colors.amber : Colors.white),
                        ),
                      ),
                    ),
                  ),
                  //search
                  Container(
                      color: const Color.fromARGB(255, 168, 213, 235),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              query = value;
                              productPage = 0;
                              filteredItems = [];
                              _filterUsingService(query);
                            },
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
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
                                  splashColor:
                                      const Color.fromARGB(255, 255, 223, 187),
                                  onTap: () {
                                    query = _searchController.text;
                                    productPage = 0;
                                    filteredItems = [];
                                    _filterUsingService(query);
                                  },
                                  child: Container(
                                    child: const Center(
                                        child: Text(
                                      "ARA",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                return _selectingAreaRowItem(
                                    filteredItems[index], () async {
                                  productName =
                                      filteredItems[index].definition!;
                                  productId = filteredItems[index].productId!;
                                  selectedItem = filteredItems[index];
                                  updateInfo();
                                  Navigator.pop(context);
                                  setState(() {});
                                });
                              },
                            ),
                            _addMoreDataButton(),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 600,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  TextButton _addMoreDataButton() {
    return TextButton(
      onPressed: () {
        _getMoreData();
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

  Card _selectingAreaRowItem(ProductItems item, Function()? onTap) {
    return Card(
      elevation: 0,
      child: InkWell(
        splashColor: Colors.deepOrangeAccent,
        onTap: onTap,
        child: ListTile(
          title: Text(
            item.definition.toString(),
            textAlign: TextAlign.center,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("On hand stock: ${item.onHandStock?.toInt()}"),
              Text("Real stock: ${item.realStock?.toInt()}"),
            ],
          ),
        ),
      ),
    );
  }

  void updateInfo() {
    widget.onValueChanged(selectedItem!);
  }
}
