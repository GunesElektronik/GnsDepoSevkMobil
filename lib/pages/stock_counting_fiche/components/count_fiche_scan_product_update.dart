import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_counting_fiche_detail.dart';

class TabbedCountFicheUpdateProduct extends StatefulWidget {
  const TabbedCountFicheUpdateProduct({
    Key? key,
    required this.oldItem,
    required this.onValueChanged,
  }) : super(key: key);

  final StockCountingFicheItems oldItem;
  final ValueChanged<StockCountingFicheItems> onValueChanged;

  @override
  State<TabbedCountFicheUpdateProduct> createState() =>
      _TabbedCountFicheUpdateProductState();
}

class _TabbedCountFicheUpdateProductState
    extends State<TabbedCountFicheUpdateProduct>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String productNameInit = "Ürün";
  late StockCountingFicheItems updatedItem;
  int qty = 1;
  List<TableRow> tableRowList = [];
  final TextEditingController _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    updatedItem = widget.oldItem;
    _createTableRows();
    qty = widget.oldItem.qty?.toInt() ?? 1;
    _qtyController.text = qty.toString();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  _createTableRows() {
    updatedItem.unit?.conversions?.forEach((conversionElement) {
      conversionElement.barcodes?.forEach((elementBarcode) {
        TableRow row = _tableRow(
          conversionElement.code ?? "",
          elementBarcode.barcode ?? "",
          conversionElement.convParam1.toString(),
          conversionElement.convParam2.toString(),
          const Color.fromARGB(255, 255, 237, 231),
        );

        tableRowList.add(row);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                padding: const EdgeInsets.only(bottom: 0),
                tabAlignment: TabAlignment.fill,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: const Color(0xff959b9b),
                indicator: BoxDecoration(
                    color: const Color(0xfffef8ec),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.deepOrange, width: 1)),
                //isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 3,
                dividerColor: Colors.deepOrange,
                tabs: const [
                  Tab(
                    child: Text(
                      "GÜNCELLE",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "BİRİMLER",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    _updateBody(),
                    _unitConversionBody(),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Column _updateBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _qtyController,
                  onChanged: (value) {
                    qty = int.tryParse(value)!;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // color: Color(0xff8a9a99),
                      color: Colors.black),
                  decoration: InputDecoration(
                      label: Text(
                        "Adet",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[200]),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // BorderRadius 5px
                        borderSide: const BorderSide(
                          color: Colors.black, // Siyah border
                          width: 1.0, // 1px kalınlık
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // BorderRadius 5px
                        borderSide: const BorderSide(
                          color: Colors.black, // Siyah border
                          width: 1.0, // 1px kalınlık
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10)),
                  cursorColor: const Color(0xff8a9a99),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: const Text(
                  "İptal",
                  style: TextStyle(color: Colors.black),
                )),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: (() {
                _updateItem();
                Navigator.of(context).pop();
              }),
              child: const Text(
                "Güncelle",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        )
      ],
    );
  }

  Container _unitConversionBody() {
    return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 255, 237, 231),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            children: [
              _tableRow("Birim", "Barkod", "KS_1", "KS_2",
                  const Color.fromARGB(255, 255, 115, 73)),
              ...List.generate(
                tableRowList.length,
                (index) => tableRowList[index],
              )
            ],
          ),
        ));
  }

  TableRow _tableRow(String unitCode, String barcode, String convParam1,
      String convParam2, Color color) {
    return TableRow(
      decoration: BoxDecoration(
        color: color,
      ),
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(unitCode),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(barcode),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(convParam1),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(convParam2),
          ),
        ),
      ],
    );
  }

  void _updateItem() {
    updatedItem.qty = qty.toDouble();
    widget.onValueChanged(updatedItem);
  }
}
