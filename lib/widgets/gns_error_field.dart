import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
GNSShowErrorMessage(BuildContext context, content) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
      ),
      actions: [
        TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            child: const Text(
              "Kapat",
              style: TextStyle(color: Colors.black),
            )),
      ],
      title: const Text("HATA !"),
      contentPadding: const EdgeInsets.all(20.0),
      content: Text(content),
    ),
  );
}
