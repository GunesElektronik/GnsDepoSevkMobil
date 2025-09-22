import 'package:flutter/material.dart';

class CountFicheItemRow extends StatefulWidget {
  const CountFicheItemRow({super.key});

  @override
  State<CountFicheItemRow> createState() => _CountFicheItemRowState();
}

class _CountFicheItemRowState extends State<CountFicheItemRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xfff1f1f1),
      child: InkWell(
        onLongPress: () {},
        highlightColor: const Color.fromARGB(255, 179, 199, 211),
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          contentPadding: const EdgeInsets.only(right: 15, left: 15),
          leading: const Text(
            "01",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 32, 32, 32),
            ),
          ),
          trailing: const Text(
            "12",
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          title: const Text(
            "123456",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff727272),
            ),
          ),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Mavi Kalem",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700]),
            ),
            // Text(
            //   "description",
            //   style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.normal,
            //       color: Colors.grey[700]),
            // )
          ]),
        ),
      ),
    );
  }
}
