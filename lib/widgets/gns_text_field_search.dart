import 'package:flutter/material.dart';

class GNSTextFieldSearch extends StatefulWidget {
  const GNSTextFieldSearch({super.key, required this.onSearchTextChange});

  @override
  State<GNSTextFieldSearch> createState() => _GNSTextFieldSearchState();
  final ValueChanged<String> onSearchTextChange;
}

class _GNSTextFieldSearchState extends State<GNSTextFieldSearch> {
  late TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 168, 213, 235),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                widget.onSearchTextChange(value);
              },
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    splashColor: const Color.fromARGB(255, 255, 223, 187),
                    onTap: () {
                      widget.onSearchTextChange(_searchController.text);
                    },
                    child: Container(
                      child: const Center(
                          child: Text(
                        "ARA",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
