import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/customer_addresses_response.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_customer.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class GNSWhsTrsCustomerBottomSheet extends StatefulWidget {
  const GNSWhsTrsCustomerBottomSheet({super.key, required this.onValueChanged});
  final ValueChanged<CustomerAndAddressNew> onValueChanged;
  @override
  State<GNSWhsTrsCustomerBottomSheet> createState() =>
      _GNSWhsTrsCustomerBottomSheetState();
}

class _GNSWhsTrsCustomerBottomSheetState
    extends State<GNSWhsTrsCustomerBottomSheet> {
  late ApiRepository apiRepository;
  TextEditingController _searchController = TextEditingController();
  List<CustomerItems> customerItems = [];
  List<CustomerItems> filteredItems = [];
  bool isFetched = false;
  bool isLoading = false;
  int customerPage = 1;
  late NewCustomerListResponse? customerResponse;
  late CustomerAddressesResponse? customerAddressesResponse;
  String query = "";

  String customerCode = "";
  String customerName = "Cari";
  String customerAddressName = "Sevk Adresi";

  String customerId = "";
  String customerAddressId = "";

  @override
  void initState() {
    super.initState();
    _createApiRepository();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    customerAddressesResponse = null;
    //customerResponse = await apiRepository.getCustomerDeneme(customerPage);
    //customerItems = customerResponse!.customers!.items!;
    customerResponse =
        await apiRepository.getCustomerDenemeSearch(customerPage, query);
    filteredItems = customerResponse!.customers!.items!;
    setState(() {
      isFetched = true;
    });
  }

  // Future<void> _getNewCustomerItems() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   customerPage++;
  //   //await Future.delayed(Duration(seconds: 3));
  //   var newResponse = await apiRepository.getCustomerDeneme(customerPage);
  //   customerItems = customerItems + newResponse!.customers!.items!;
  //   filteredItems = customerItems;

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // void filterSearchResults(String query) {
  //   List<CustomerItems> dummySearchList = [];
  //   dummySearchList.addAll(customerItems);
  //   if (query.isNotEmpty) {
  //     List<CustomerItems> dummyListData = [];
  //     dummySearchList.forEach((item) {
  //       if (item.name!.toLowerCase().contains(query.toLowerCase())) {
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       filteredItems = dummyListData;
  //     });
  //   } else {
  //     setState(() {
  //       filteredItems = customerItems;
  //     });
  //   }
  // }

  void _filterUsingService(String query) async {
    customerPage++;
    setState(() {
      isLoading = true;
    });
    var newResponse =
        await apiRepository.getCustomerDenemeSearch(customerPage, query);
    filteredItems = filteredItems + newResponse!.customers!.items!;

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
                          isLoading ? "Yükleniyor ..." : "Cariler",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isLoading ? Colors.amber : Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      color: const Color.fromARGB(255, 168, 213, 235),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              query = value;
                              customerPage = 0;
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
                                    customerPage = 0;
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
                                    filteredItems[index].name!, () async {
                                  customerCode = filteredItems[index].code!;
                                  customerName = filteredItems[index].name!;
                                  customerId = filteredItems[index].customerId!;

                                  customerAddressName = "Sevk Adresi";
                                  customerAddressId = "";
                                  // _showLoadingScreen(true, "Yükleniyor...");
                                  // customerAddressesResponse = await apiRepository
                                  //     .getCustomerAddresses(customerId);
                                  // _showLoadingScreen(false, "Yükleniyor...");
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

  Card _selectingAreaRowItem(String title, Function()? onTap) {
    return Card(
      elevation: 0,
      child: InkWell(
        splashColor: Colors.deepOrangeAccent,
        onTap: onTap,
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void updateInfo() {
    CustomerAndAddressNew info = CustomerAndAddressNew(
      customerCode: customerCode,
      customerId: customerId,
      customerName: customerName,
      customerAddressId: customerAddressId,
      customerAddressName: customerAddressName,
    );
    widget.onValueChanged(info);
  }
}

class CustomerAndAddressNew {
  final String customerCode;
  final String customerId;
  final String customerName;
  final String customerAddressId;
  final String customerAddressName;

  CustomerAndAddressNew({
    required this.customerCode,
    required this.customerId,
    required this.customerName,
    required this.customerAddressId,
    required this.customerAddressName,
  });
}
