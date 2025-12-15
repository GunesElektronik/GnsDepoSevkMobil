import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/constants/custom_colors.dart';
import 'package:gns_warehouse/constants/customer_address_type.dart';
import 'package:gns_warehouse/models/new_api/customer_addresses_response.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_customer_bottom.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class GNSSelectCustomerAndAddress extends StatefulWidget {
  GNSSelectCustomerAndAddress({
    super.key,
    required this.isErrorActiveForCustomer,
    required this.isErrorActiveForCustomerAddress,
    required this.response,
    required this.onValueChanged,
    required this.addressType,
  });

  NewCustomerListResponse response;
  final bool isErrorActiveForCustomer;
  final bool isErrorActiveForCustomerAddress;
  final ValueChanged<CustomerAndAddress> onValueChanged;
  final CustomerAddressType addressType;
  @override
  State<GNSSelectCustomerAndAddress> createState() => _GNSSelectCustomerAndAddressState();
}

class _GNSSelectCustomerAndAddressState extends State<GNSSelectCustomerAndAddress> {
  late ApiRepository apiRepository;
  //int customerPage = 1;

  //final scrollController = ScrollController();
  //List<CustomerItems> customerItems = [];
  bool isFetched = false;
  //late NewCustomerListResponse? customerResponse;
  late CustomerAddressesResponse? customerAddressesResponse;

  String customerNameInit = "Cari";
  String customerAddressNameInit = "Sevk Adresi";

  String customerName = "Cari";
  String customerAddressName = "Sevk Adresi";

  String customerId = "";
  String customerAddressId = "";

  bool isErrorActiveForCustomer = false;
  bool isErrorActiveForCustomerAddress = false;

  String addressDetail = "";

  Color errorColor = GNSCustomColor().errorColor;

  @override
  void initState() {
    super.initState();
    //scrollController.addListener(_scrollListener);
    customerAddressNameInit = getCustomerAddressTypeText();
    customerAddressName = getCustomerAddressTypeText();
    isErrorActiveForCustomer = widget.isErrorActiveForCustomer;
    isErrorActiveForCustomerAddress = widget.isErrorActiveForCustomerAddress;
    _createApiRepository();
  }

  @override
  void didUpdateWidget(GNSSelectCustomerAndAddress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isErrorActiveForCustomer != widget.isErrorActiveForCustomer) {
      isErrorActiveForCustomer = widget.isErrorActiveForCustomer;
      setState(() {});
    }

    if (oldWidget.isErrorActiveForCustomerAddress != widget.isErrorActiveForCustomerAddress) {
      isErrorActiveForCustomerAddress = widget.isErrorActiveForCustomerAddress;
      setState(() {});
    }
  }

  String getCustomerAddressTypeText() {
    switch (widget.addressType) {
      case CustomerAddressType.shippingAddress:
        return "Sevk Adresi";
      case CustomerAddressType.invoiceAddress:
        return "Fatura Adresi";
      case CustomerAddressType.both:
        return "Adres";
    }
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    //customerResponse = await apiRepository.getCustomerDeneme(customerPage);
    //customerItems = customerResponse!.customers!.items!;
    customerAddressesResponse = null;
    setState(() {
      isFetched = true;
    });
  }

  // Future<void> _getNewCustomerItems() async {
  //   customerPage++;
  //   var newResponse = await apiRepository.getCustomerDeneme(customerPage);
  //   customerItems = customerItems + newResponse!.customers!.items!;

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return isFetched
        ? Column(
            children: [
              _row(customerName, customerNameInit, isErrorActiveForCustomer, () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  // builder: (context) =>
                  //     _customerListBottomSheet(widget.response),

                  //klavye açıldığında bottomSheeti üste çıkartmak için
                  // padding: EdgeInsets.only(
                  //   bottom: MediaQuery.of(context).viewInsets.bottom,
                  // ),
                  builder: (context) => GNSWhsTrsCustomerBottomSheet(
                    onValueChanged: (value) async {
                      customerName = value.customerName;
                      customerId = value.customerId;
                      customerAddressName = getCustomerAddressTypeText();
                      customerAddressId = "";

                      _showLoadingScreen(true, "Yükleniyor...");
                      customerAddressesResponse = await apiRepository.getCustomerAddresses(customerId);
                      if (customerAddressesResponse != null) {
                        if (customerAddressesResponse!.addresses != null) {
                          if (customerAddressesResponse!.addresses!.length == 1) {
                            customerAddressName = customerAddressesResponse!.addresses![0].name!;
                            customerAddressId = customerAddressesResponse!.addresses![0].customerAddressId!;
                            addressDetail = customerAddressesResponse!.addresses![0].description!;
                          }
                        }
                      }
                      updateInfo();
                      _showLoadingScreen(false, "Yükleniyor...");
                      setState(() {});
                    },
                  ),
                );
              }),
              SizedBox(
                height: customerAddressesResponse != null ? 5 : 0,
              ),
              customerAddressesResponse != null
                  ? _row(
                      customerAddressName,
                      customerAddressNameInit,
                      isErrorActiveForCustomerAddress,
                      () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _customerAddressesListBottomSheet(customerAddressesResponse!),
                        );
                      },
                    )
                  : SizedBox(),
              SizedBox(
                height: customerAddressesResponse != null ? 5 : 0,
              ),
              customerAddressesResponse != null
                  ? Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        minHeight: 50,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black, // Çerçeve rengi
                          width: 1.0, // Çerçeve kalınlığı
                        ),
                        borderRadius: BorderRadius.circular(5), // Köşe yuvarlama
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            addressDetail,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[200],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          )
        : CircularProgressIndicator();
  }

  // void _scrollListener() {
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     _getNewCustomerItems();
  //     print("scroll listener working");
  //   } else {
  //     print("çalışmadı");
  //   }
  // }

  Row _row(String title, String initTitle, bool isErrorActive, Function()? onTap) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: Border.all(
                color: isErrorActive ? errorColor : Colors.black,
                width: isErrorActive ? 1.5 : 1,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: title == initTitle ? Colors.blueGrey[200] : Colors.black,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        SizedBox(
          height: 50,
          width: 50,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              splashColor: Color.fromARGB(255, 255, 223, 187),
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                    border: Border(
                      top: BorderSide(
                        width: isErrorActive ? 1.5 : 1,
                        color: isErrorActive ? errorColor : Colors.black,
                      ),
                      bottom: BorderSide(
                        width: isErrorActive ? 1.5 : 1,
                        color: isErrorActive ? errorColor : Colors.black,
                      ),
                      right: BorderSide(
                        width: isErrorActive ? 1.5 : 1,
                        color: isErrorActive ? errorColor : Colors.black,
                      ),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.view_list_rounded,
                    color: Colors.blueGrey[300],
                    size: 30,
                  ))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _customerListBottomSheet(NewCustomerListResponse response) {
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
                    "Cariler",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: response.customers!.items!.length,
                    itemBuilder: (context, index) {
                      return _selectingAreaRowItem(response.customers!.items![index].name!, () async {
                        customerName = response.customers!.items![index].name!;
                        customerId = response.customers!.items![index].customerId!;
                        customerAddressName = getCustomerAddressTypeText();
                        customerAddressId = "";
                        _showLoadingScreen(true, "Yükleniyor...");
                        customerAddressesResponse = await apiRepository.getCustomerAddresses(customerId);
                        _showLoadingScreen(false, "Yükleniyor...");
                        updateInfo();
                        Navigator.pop(context);
                        setState(() {});
                      });
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

  void updateInfo() {
    CustomerAndAddress info = CustomerAndAddress(
      customerId: customerId,
      customerAddressId: customerAddressId,
    );
    widget.onValueChanged(info);
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

  Widget _customerAddressesListBottomSheet(CustomerAddressesResponse response) {
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    getCustomerAddressTypeText(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: response.addresses!.length,
                    itemBuilder: (context, index) {
                      if (widget.addressType == CustomerAddressType.both) {
                        return _selectingAreaRowItem(response.addresses![index].name!, () {
                          customerAddressName = response.addresses![index].name!;
                          customerAddressId = response.addresses![index].customerAddressId!;
                          addressDetail = response.addresses![index].description!;
                          updateInfo();
                          Navigator.pop(context);
                          setState(() {});
                        });
                      }

                      if (widget.addressType == CustomerAddressType.invoiceAddress) {
                        if (response.addresses![index].isDefault!) {
                          return _selectingAreaRowItem(response.addresses![index].name!, () {
                            customerAddressName = response.addresses![index].name!;
                            customerAddressId = response.addresses![index].customerAddressId!;
                            addressDetail = response.addresses![index].description!;
                            updateInfo();
                            Navigator.pop(context);
                            setState(() {});
                          });
                        } else {
                          return const SizedBox.shrink();
                        }
                      }

                      if (widget.addressType == CustomerAddressType.shippingAddress) {
                        if (!response.addresses![index].isDefault!) {
                          return _selectingAreaRowItem(response.addresses![index].name!, () {
                            customerAddressName = response.addresses![index].name!;
                            customerAddressId = response.addresses![index].customerAddressId!;
                            addressDetail = response.addresses![index].description!;
                            updateInfo();
                            Navigator.pop(context);
                            setState(() {});
                          });
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
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
}

class CustomerAndAddress {
  final String customerId;
  final String customerAddressId;

  CustomerAndAddress({
    required this.customerId,
    required this.customerAddressId,
  });
}
