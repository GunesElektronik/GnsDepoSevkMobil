import 'dart:async';
import 'dart:io' show Directory;

import 'package:gns_warehouse/database/model/waybills_local.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

class DbHelperForWaybills {
  static const _databaseName = "Gns.db";
  static const _databaseVersion = 1;

  DbHelperForWaybills._privateConstructor();
  static final DbHelperForWaybills instance =
      DbHelperForWaybills._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: createDb);
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE LocalWaybills (recid INTEGER PRIMARY KEY AUTOINCREMENT,waybillsId NVARCHAR(40),docNo NVARCHAR(40),ficheNo NVARCHAR(40),customerId NVARCHAR(40),salesmanId NVARCHAR(40), ficheDate INTEGER, shipDate INTEGER, workplaceId NVARCHAR(40), departmentId NVARCHAR(40), warehouseId NVARCHAR(40), transporterId NVARCHAR(40), shippingTypeId NVARCHAR(40), waybillStatusId NVARCHAR(40), currencyId INTEGER,totaldiscounted DOUBLE,totalvat DOUBLE,grosstotal DOUBLE,shippingAccountId NVARCHAR(40), shippingAddressId NVARCHAR(40),description NVARCHAR(40))");
  }

  Future<String> findDatabasePath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'Gns.db');
  }

  Future<int> addMultiOrder(WaybillLocalModel waybill) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO LocalWaybills(waybillsId, docNo , ficheNo, customerId, salesmanId, ficheDate,shipDate,workplaceId,departmentId, warehouseId, transporterId,shippingTypeId, waybillStatusId, currencyId, totaldiscounted,totalvat, grosstotal, shippingAccountId, shippingAddressId, description) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          waybill.waybillsId,
          waybill.docNo,
          waybill.ficheNo,
          waybill.customerId,
          waybill.salesmanId,
          waybill.ficheDate!.millisecondsSinceEpoch,
          waybill.shipDate!.millisecondsSinceEpoch,
          waybill.workplaceId,
          waybill.departmentId,
          waybill.warehouseId,
          waybill.transporterId,
          waybill.shippingTypeId,
          waybill.waybillStatusId,
          waybill.currencyId,
          waybill.totaldiscounted,
          waybill.totalvat,
          waybill.grosstotal,
          waybill.shippingAccountId,
          waybill.shippingAddressId,
          waybill.description,
        ]);

    return inserted;
  }
/*
  Future<List<WaybillLocalModel>?> getMultiOrderHeaderList() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query("LocalWaybills", orderBy: "ficheDate DESC");

    var headers = List.generate(maps.length, (i) {
      return WaybillLocalModel(
        maps[i]["waybillsId"],
        maps[i]["docNo"],
        maps[i]["ficheNo"],
        maps[i]["customerId"],
        maps[i]["salesmanId"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        DateTime.fromMillisecondsSinceEpoch(maps[i]["shipDate"] as int),
        maps[i]["workplaceId"],
        maps[i]["departmentId"],
        maps[i]["warehouseId"],
        maps[i]["transporterId"],
        maps[i]["shippingTypeId"],
        maps[i]["waybillStatusId"],
        maps[i]["currencyId"],
        maps[i]["totaldiscounted"],
        maps[i]["totalvat"],
        maps[i]["grosstotal"],
        maps[i]["shippingAccountId"],
        maps[i]["shippingAddressId"],
        maps[i]["description"],
      );
    }).toList();

    return headers;
  }

  Future<int> addMultiOrderHeaders(List<WaybillLocalModel> summaries) async {
    clearAllMultiOrderHeader();
    summaries.forEach((summary) async {
      addMultiOrder(summary);
    });
    return 0;
  }

  Future<int> updateMultiOrderHeader(WaybillLocalModel header) async {
    Database db = await instance.database;
    return await db.update("LocalWaybills", header.toMap(),
        where: "waybillsId=?", whereArgs: [header.waybillsId]);
  }

  Future<int> removeMultiOrderHeader(String waybillsId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybills",
        where: "waybillsId=?", whereArgs: [waybillsId]);
  }

  Future<int> getMultiOrderHeaderCount() async {
    Database? db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query("LocalWaybills");

    return maps.toList().length;
  }

  Future<int> clearAllMultiOrderHeader() async {
    Database db = await instance.database;
    return await db.delete("LocalWaybills");
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
*/
}
