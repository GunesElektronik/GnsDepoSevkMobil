import 'package:flutter/material.dart';

class GNSFilterButton extends StatefulWidget {
  const GNSFilterButton({
    super.key,
    required this.onValueChanged,
    required this.activeIcon,
    required this.passiveIcon,
  });

  @override
  State<GNSFilterButton> createState() => _GNSFilterButtonState();
  final ValueChanged<bool> onValueChanged;
  final IconData activeIcon;
  final IconData passiveIcon;
}

class _GNSFilterButtonState extends State<GNSFilterButton> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              splashColor: const Color.fromARGB(255, 255, 223, 187),
              onTap: () {
                isVisible = !isVisible;
                widget.onValueChanged(isVisible);
                setState(() {});
              },
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                    // border: Border(
                    //   top: BorderSide(
                    //     width: 1,
                    //   ),
                    //   bottom: BorderSide(
                    //     width: 1,
                    //   ),
                    //   right: BorderSide(
                    //     width: 1,
                    //   ),
                    // ),
                  ),
                  child: Center(
                      child: Icon(
                    isVisible ? widget.activeIcon : widget.passiveIcon,
                    color: Colors.blueGrey[300],
                    size: 30,
                  ))),
            ),
          ),
        ),
      ],
    );
  }
}
