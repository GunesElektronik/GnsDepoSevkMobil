import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/users/user_list_response.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/user_special_settings.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late ApiRepository apiRepository;
  late TextEditingController _searchController;
  List<UserListResponse>? userListResponse = [];

  int userListPage = 1;
  String query = "";
  bool isFetched = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    userListResponse = await apiRepository.getUserList(1, "");
    setState(() {
      isFetched = true;
    });
  }

  void _filterOrderUsingService(String newQuery) async {
    userListPage++;
    setState(() {
      isLoading = true;
    });
    var newResponse = await apiRepository.getUserList(userListPage, newQuery);
    userListResponse = userListResponse! + newResponse!;
    setState(() {
      isLoading = false;
    });
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;

    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isFetched
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                top: 0, right: 8, bottom: 0, left: 8),
                            itemCount: userListResponse!.length,
                            itemBuilder: (context, index) {
                              return _row(userListResponse![index], index + 1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  TextButton _addMoreDataButton() {
    return TextButton(
      onPressed: () {
        _filterOrderUsingService(query);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        'Daha Fazla Yükle',
        style: TextStyle(
            color: Colors.deepOrange, // Metin rengi
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container _searchBar() {
    return Container(
        color: Color.fromARGB(255, 255, 240, 152),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                query = value;
                userListPage = 0;
                _filterOrderUsingService(value);
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
                      query = _searchController.text;
                      userListPage = 0;
                      userListResponse = [];
                      _filterOrderUsingService(_searchController.text);
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

  Padding _row(UserListResponse item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 221, 121),
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20),
          minVerticalPadding: 1,
          leading: Text(
            index < 10 ? '0$index' : index.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          title: Text(
            capitalize(item.name.toString()),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                capitalize(item.surname.toString()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              // RichText(
              //   text: TextSpan(
              //     style: const TextStyle(fontSize: 10, color: Colors.black),
              //     children: <TextSpan>[
              //       const TextSpan(
              //           text: 'Ürün Sayısı: ',
              //           style: TextStyle(
              //               fontSize: 13, fontWeight: FontWeight.bold)),
              //       TextSpan(
              //           text: '${item.ficheTime}',
              //           style: const TextStyle(
              //             fontSize: 13,
              //           )),
              //     ],
              //   ),
              // ),
            ],
          ),

          //isThreeLine: true,
          onTap: () {
            showDialogForOptions(context, item);
          },
          onLongPress: () {},
          dense: true,
        ),
      ),
    );
  }

  Future<dynamic> showDialogForOptions(
      BuildContext context, UserListResponse user) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
        ),
        title: const Text("Seçenekler"),
        contentPadding: const EdgeInsets.all(10.0),
        content: Container(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _optionButton("Ambar Ayarları", () {
                  Navigator.of(context).push<String>(MaterialPageRoute(
                    builder: (context) => UserSpecialSettingsPage(
                      user: user,
                    ),
                  ));
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text(
                "İptal",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  Padding _optionButton(String title, Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.orangeAccent,
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: const Color.fromARGB(255, 255, 223, 187),
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: isLoading
          ? const CircularProgressIndicator()
          : Text(
              "Kullanıcı Listesi",
              style: TextStyle(
                  color: Colors.deepOrange[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
