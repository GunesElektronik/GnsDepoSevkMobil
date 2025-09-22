import 'package:flutter/material.dart';

class GNSCheckBox extends StatefulWidget {
  GNSCheckBox(
      {super.key,
      required this.isChecked,
      required this.title,
      required this.valueChanged});

  @override
  State<GNSCheckBox> createState() => _GNSCheckBoxState();
  bool isChecked;
  String title;
  final ValueChanged<bool> valueChanged;
}

class _GNSCheckBoxState extends State<GNSCheckBox> {
  late bool isChecked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue!;
              widget.valueChanged(isChecked);
            });
          },
          activeColor: Colors.amber,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
                widget.valueChanged(isChecked);
              });
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
