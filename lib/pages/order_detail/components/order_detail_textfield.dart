import 'package:flutter/material.dart';

class GNSOrderDetailTextField extends StatefulWidget {
  GNSOrderDetailTextField({super.key, required this.onValueChanged});

  @override
  State<GNSOrderDetailTextField> createState() =>
      _GNSOrderDetailTextFieldState();

  final ValueChanged<String?> onValueChanged;
}

class _GNSOrderDetailTextFieldState extends State<GNSOrderDetailTextField> {
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  TextEditingController barcodeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        widget.onValueChanged(value);
      },
      focusNode: _focusNode,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: _isFocused ? Colors.amber : Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.all(5),
        hintText: 'BARCODE',
      ),
      textAlign: TextAlign.center,
      controller: barcodeController,
    );
  }
}
