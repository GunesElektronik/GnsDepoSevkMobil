import 'package:flutter/material.dart';

class GNSTextField extends StatefulWidget {
  GNSTextField({super.key, required this.label, required this.onValueChanged});
  final ValueChanged<String?> onValueChanged;
  final String label;
  @override
  State<GNSTextField> createState() => _GNSTextFieldState();
}

class _GNSTextFieldState extends State<GNSTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        widget.onValueChanged(value);
      },
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.start,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          // color: Color(0xff8a9a99),
          color: Colors.black),
      decoration: InputDecoration(
          label: Text(
            widget.label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[200]),
          ),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // BorderRadius 5px
            borderSide: const BorderSide(
              color: Colors.black, // Siyah border
              width: 1.0, // 1px kalınlık
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // BorderRadius 5px
            borderSide: const BorderSide(
              color: Colors.black, // Siyah border
              width: 1.0, // 1px kalınlık
            ),
          ),
          contentPadding: EdgeInsets.all(10)),
      cursorColor: const Color(0xff8a9a99),
    );
  }

  //  ElevatedButton(
  //         onPressed: () {
  //           showModalBottomSheet(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return Container(
  //                 height: 200,
  //                 color: Colors.white,
  //                 child: Center(
  //                   child: Text(
  //                     'Bu bir Bottom Sheet\'tir',
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //         child: Text('Bottom Sheet Aç'),
  //       ),

  // Widget _shippingTypeBottomSheet(ShippingTypeListResponse response) {
  //   double leftPadding = 8.0;
  //   return Container(
  //     width: double.infinity,
  //     height: 400,
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20.0),
  //         topRight: Radius.circular(20.0),
  //       ),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(5.0),
  //       child: Column(
  //         children: [
  //           //Geçmiş İşlemler Text
  //           Container(
  //             decoration: BoxDecoration(
  //               color: Colors.deepOrange[700],
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(20.0),
  //                 topRight: Radius.circular(20.0),
  //               ),
  //             ),
  //             child: const Center(
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 12),
  //                 child: Text(
  //                   "Shipping Type",
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                       color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     ListView.builder(
  //                       primary: false,
  //                       shrinkWrap: true,
  //                       itemCount: response.shippingType!.items!.length,
  //                       itemBuilder: (context, index) {
  //                         return _selectingAreaRowItem(
  //                             response.shippingType!.items![index].code!, () {
  //                           shippingTypeId = response
  //                               .shippingType!.items![index].shippingTypeId!;
  //                           shippingType =
  //                               response.shippingType!.items![index].code!;
  //                           Navigator.pop(context);
  //                           setState(() {});
  //                         });
  //                       },
  //                     )
  //                   ]),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
