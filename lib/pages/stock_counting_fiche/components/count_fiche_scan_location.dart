import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountFicheScanLocation extends StatefulWidget {
  const CountFicheScanLocation({
    super.key,
    required this.onBarcodeChanged,
  });
  final ValueChanged<String?> onBarcodeChanged;

  @override
  State<CountFicheScanLocation> createState() => _CountFicheScanLocationState();
}

class _CountFicheScanLocationState extends State<CountFicheScanLocation>
    with TickerProviderStateMixin {
  final TextEditingController _barcodeController = TextEditingController();

  final FocusNode _barcodeFocusNode = FocusNode();
  bool _isKeyboardVisible = true;
  TextInputType textInputType = TextInputType.text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _barcodeController.dispose();
    _barcodeFocusNode.dispose();
  }

  void _toggleKeyboard() {
    _isKeyboardVisible = !_isKeyboardVisible;

    if (_isKeyboardVisible) {
      textInputType = TextInputType.text;
      setState(() {});
      _barcodeFocusNode.unfocus();
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
    } else {
      textInputType = TextInputType.none;
      setState(() {});
      _barcodeFocusNode.unfocus();
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _barcodeScanner();
  }

  Row _barcodeScanner() {
    return Row(
      children: [
        //barcode
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.barcode_reader,
                      color: Color(0xff8a9a99),
                    )),
                Expanded(
                  child: TextField(
                    focusNode: _barcodeFocusNode,
                    keyboardType: textInputType,
                    //autofocus: true,
                    controller: _barcodeController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _barcodeHasChanged(value);

                        _barcodeController.text = "";
                        _barcodeFocusNode.requestFocus();
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    cursorColor: const Color(0xff8a9a99),
                  ),
                ),
                IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 30,
                    onPressed: () {
                      _toggleKeyboard();
                    },
                    icon: Icon(
                        _isKeyboardVisible
                            ? Icons.keyboard_alt_rounded
                            : Icons.keyboard_alt_outlined,
                        color: Colors.black)),
                IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 38,
                    onPressed: () {
                      _barcodeHasChanged(_barcodeController.text);
                      //_barcodeController.text = "";
                      _barcodeFocusNode.requestFocus();
                    },
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _barcodeHasChanged(value) {
    if (value.isNotEmpty) {
      widget.onBarcodeChanged(value);
    }
  }
}
