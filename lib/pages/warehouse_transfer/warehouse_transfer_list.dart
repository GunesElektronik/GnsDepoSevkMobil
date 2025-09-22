import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/warehouse_transfer_list_response.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/warehouse_transfer_create.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/warehouse_transfer_item_detail.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class WarehouseTransferList extends StatefulWidget {
  const WarehouseTransferList({super.key});

  @override
  State<WarehouseTransferList> createState() => _WarehouseTransferListState();
}

class _WarehouseTransferListState extends State<WarehouseTransferList> {
  late ApiRepository apiRepository;
  late WarehouseTransferListResponse? warehouseTransferListResponse;

  bool isFetched = false;

  @override
  void initState() {
    super.initState();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    warehouseTransferListResponse =
        await apiRepository.getWarehouseTransferList();

    setState(() {
      isFetched = true;
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
                  _createWarehouseTransferButton(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 0, right: 8, bottom: 0, left: 8),
                        itemCount: warehouseTransferListResponse != null
                            ? warehouseTransferListResponse!
                                .warehouseTransfers!.items!.length
                            : 0,
                        itemBuilder: (context, index) {
                          return _row(warehouseTransferListResponse!
                              .warehouseTransfers!.items![index]);
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
                                const WarehouseTransferCreatePage()))
                    .then((value) async {
                  setState(() {
                    isFetched = false;
                  });
                  warehouseTransferListResponse =
                      await apiRepository.getWarehouseTransferList();

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
                        "Ambar Transfer Oluştur",
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

  Padding _row(WarehouseTransferListItems item) {
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
                "${item.outWarehouse?.definition.toString()} -> ${item.inWarehouse?.definition.toString()}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'Ürün Sayısı: ',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '${item.warehouseTransferItems!.length}',
                        style: const TextStyle(
                          fontSize: 13,
                        )),
                  ],
                ),
              ),
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
                    builder: (context) => WarehouseTransferItemDetail(
                          item: item,
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
      title: Text(
        "Ambar Transfer Listesi",
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
