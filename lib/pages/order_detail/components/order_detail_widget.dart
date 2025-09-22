import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/order_detail_response.dart';

class OrderDetailWidget extends StatefulWidget {
  OrderDetailWidget({super.key, required this.orderDetailData});
  OrderDetailData? orderDetailData;

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  Color secondaryColor = const Color.fromARGB(255, 58, 58, 58);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth,
      color: const Color.fromARGB(255, 241, 241, 241),
      child: SingleChildScrollView(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: widget.orderDetailData!.orderItems!.length,
            itemBuilder: (context, index) {
              return _orderItemCard(widget.orderDetailData!.orderItems![index]);
            }),
      ),
    );
  }

  Card _orderItemCard(OrderItems item) {
    return Card(
      color: Color.fromARGB(255, 249, 255, 215),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: _text(item.product!.code.toString(), FontWeight.w700,
                        20, Colors.black, TextAlign.start)),
                Expanded(
                    flex: 2,
                    child: _text("Miktar: ${item.qty!.value}", FontWeight.w700,
                        20, Colors.black, TextAlign.end)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: _text(item.product!.barcode.toString(),
                        FontWeight.w500, 17, Colors.grey, TextAlign.start)),
                Expanded(
                    flex: 2,
                    child: _text("Fiyat: ${item.price!.value}", FontWeight.w500,
                        17, Colors.grey, TextAlign.end)),
              ],
            ),

            /*
            Column(
              children: [
                _textForStart(item.product!.code.toString(), FontWeight.w700,
                    20, Colors.black, 0),
                _textForStart(item.product!.barcode.toString(), FontWeight.w500,
                    15, Colors.grey, 5),
              ],
            ),
            Column(
              children: [
                _textForStart("Qty: ${item.qty!.value}", FontWeight.w700, 18,
                    Colors.black, 5),
                _textForStart("Price: ${item.price!.value}", FontWeight.w700,
                    18, Colors.black, 10),
              ],
            )
            */
            /*
            const Divider(
              thickness: 2,
              indent: 0,
              endIndent: 0,
              color: Color.fromARGB(132, 226, 193, 94),
              height: 15,
            ),
            _textForStart(item.product!.definition.toString(), FontWeight.w500,
                15, Colors.black, 5),
            _textForStart(item.product!.definition2.toString(), FontWeight.w400,
                13, Colors.black, 10),
            _textForStart("Marka: ${item.product!.brand.toString()}",
                FontWeight.w500, 15, secondaryColor, 10),
            _textForStart(
                "Oluşturulma Zamanı: ${item.createdTime.toString().substring(0, 10)}",
                FontWeight.w500,
                15,
                secondaryColor,
                10),
            _textForStart("Depo: ${item.warehouse!.definition.toString()}",
                FontWeight.w500, 15, secondaryColor, 10),
            const Divider(
              thickness: 2,
              indent: 0,
              endIndent: 0,
              color: Color.fromARGB(132, 226, 193, 94),
              height: 15,
            ),
            */

            /*
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _orderItemFicheMoney(
                      "Total", item.total.toString(), Colors.blue, 5, 0, 0, 5),
                  _orderItemFicheMoney("Discount", item.discount.toString(),
                      Colors.amber, 0, 0, 0, 0),
                  _orderItemFicheMoney(
                      "Tax", item.tax.toString(), Colors.redAccent, 0, 0, 0, 0),
                  _orderItemFicheMoney("Net Total", item.nettotal.toString(),
                      Colors.green, 0, 5, 5, 0),
                ],
              ),
            )
            */
          ],
        ),
      ),
    );
  }

  Text _text(String title, FontWeight fontWeight, double fontSize,
      Color fontColor, TextAlign align) {
    return Text(
      title,
      textAlign: align,
      style: TextStyle(
          fontWeight: fontWeight, fontSize: fontSize, color: fontColor),
    );
  }

  Row _textForStart(String definition, FontWeight fontWeight, double fontSize,
      Color fontColor, double topPadding) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                definition,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                    color: fontColor),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Expanded _orderItemFicheMoney(
      String title,
      String money,
      Color color,
      double topLeftRadius,
      double topRightRadius,
      double bottomRightRadius,
      double bottomLeftRadius) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topLeftRadius),
                    topRight: Radius.circular(topRightRadius),
                    bottomLeft: Radius.circular(bottomLeftRadius),
                    bottomRight: Radius.circular(bottomRightRadius))),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    money,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )));
  }
}
