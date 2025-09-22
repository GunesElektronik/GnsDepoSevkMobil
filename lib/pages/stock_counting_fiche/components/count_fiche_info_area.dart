import 'package:flutter/material.dart';
import 'package:gns_warehouse/widgets/gns_app_bar.dart';

// ignore: must_be_immutable
class CountFicheInfoArea extends StatefulWidget {
  CountFicheInfoArea({super.key});

  @override
  State<CountFicheInfoArea> createState() => _CountFicheInfoAreaState();
}

class _CountFicheInfoAreaState extends State<CountFicheInfoArea> {
  bool isInfoAreaVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GnsAppBar("Stok Sayım Fişi Okutma", context, actions: [
          _showInfoButton(),
        ]),
        const SizedBox(
          height: 5,
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 217, 229, 231),
          ),
          duration: const Duration(milliseconds: 100),
          height: isInfoAreaVisible ? 120 : 0,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const Text("Sayım Fişi Detay Bilgileri");
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconButton _showInfoButton() {
    return IconButton(
      icon: isInfoAreaVisible
          ? const Icon(Icons.info_outline_rounded)
          : const Icon(Icons.info_rounded),
      onPressed: () {
        isInfoAreaVisible = !isInfoAreaVisible;
        setState(() {});
      },
    );
  }
}
