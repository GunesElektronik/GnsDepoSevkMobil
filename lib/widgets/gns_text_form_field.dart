import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GNSTextFormField extends StatefulWidget {
  GNSTextFormField({
    super.key,
    required this.label,
    required this.onValueChanged,
    this.maxLength = TextField.noMaxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
  });
  final ValueChanged<String?> onValueChanged;
  final String label;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int maxLength;
  @override
  State<GNSTextFormField> createState() => _GNSTextFormFieldState();
}

class _GNSTextFormFieldState extends State<GNSTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        widget.onValueChanged(value);
      },
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.start,
      maxLength:
          widget.maxLength == TextField.noMaxLength ? null : widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[200],
        ),
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
      cursorColor: const Color(0xff8a9a99),
    );
  }
}
