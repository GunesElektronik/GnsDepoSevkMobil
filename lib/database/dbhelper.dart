import 'dart:async';
import 'dart:io' show Directory;
import 'package:gns_warehouse/database/model/order_detail_scanned_item.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_item_db.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_scanned_item.dart';
import 'package:gns_warehouse/database/model/waybills_item_loca.dart';
import 'package:gns_warehouse/database/model/waybills_local.dart';
import 'package:gns_warehouse/database/model/waybills_scanned_item.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/order_header_response_new.dart';
import 'package:gns_warehouse/models/new_api/order_item_entity.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/models/purchase_order_summary_local.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

import '../models/order_summary.dart';
import '../models/order_summary_entity.dart';

class DbHelper {
  static const _databaseName = "Gns.db";
  static const _databaseVersion = 1;

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

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
        "CREATE TABLE OrderHeader (recid INTEGER PRIMARY KEY AUTOINCREMENT,id NVARCHAR(40), ficheNo NVARCHAR(40), ficheDate INTEGER, customer NVARCHAR(250), shippingMethod NVARCHAR(100), warehouse NVARCHAR(150), lineCount NVARCHAR(10), orderStatus NVARCHAR(40), totalQty NVARCHAR(10), total NVARCHAR(40), isAssing INTEGER, assingmentEmail NVARCHAR(120), assingCode NVARCHAR(80), assingmetFullname NVARCHAR(120), isPartialOrder INTEGER, cancelled INTEGER)");
    await db.execute(
        "CREATE TABLE OrderHeaderDetailItems (recid INTEGER PRIMARY KEY AUTOINCREMENT,orderId NVARCHAR(40), orderItemId NVARCHAR(40), productId NVARCHAR(40), warehouseId NVARCHAR(40), stockLocationId NVARCHAR(40), ficheNo NVARCHAR(40), productName NVARCHAR(40), productBarcode NVARCHAR(20), warehouse NVARCHAR(150), isProductLocatin INTEGER, isExceededStockCount INTEGER ,stockLocationName NVARCHAR(150) ,serilotType INTEGER,scannedQty INTEGER,  qty INTEGER, shippedQty INTEGER)");
    await db.execute(
        "CREATE TABLE OrderDetailScannedItems (recid INTEGER PRIMARY KEY AUTOINCREMENT, ficheNo NVARCHAR(40), orderItemId NVARCHAR(40),productBarcode NVARCHAR(20), warehouse NVARCHAR(40) , stockLocationId NVARCHAR(40) ,stockLocationName NVARCHAR(40) ,numberOfPieces INTEGER)");
    await db.execute(
        "CREATE TABLE ProcessHistory (id INTEGER PRIMARY KEY AUTOINCREMENT, processId INTEGER, processUid  NVARCHAR(40), processName NVARCHAR(150), recordDate INTEGER )");
    await db.execute(
        "CREATE TABLE PurchaseOrderSummary (recid INTEGER PRIMARY KEY AUTOINCREMENT,purchaseOrderId NVARCHAR(40), ficheNo NVARCHAR(40), ficheDate INTEGER, customer NVARCHAR(250), shippingMethod NVARCHAR(100), warehouse NVARCHAR(150), lineCount NVARCHAR(10), orderStatus NVARCHAR(40), totalQty NVARCHAR(10), total NVARCHAR(40), isAssing INTEGER, assingmentEmail NVARCHAR(120), assingCode NVARCHAR(80), assingmetFullname NVARCHAR(120), isPartialOrder INTEGER)");
    await db.execute(
        "CREATE TABLE PurchaseOrderDetailItems (recid INTEGER PRIMARY KEY AUTOINCREMENT,purchaseOrderId NVARCHAR(40), orderItemId NVARCHAR(40), productId NVARCHAR(40), warehouseId NVARCHAR(40), stockLocationId NVARCHAR(40), ficheNo NVARCHAR(40), productName NVARCHAR(40), productBarcode NVARCHAR(20), warehouse NVARCHAR(150), isProductLocatin INTEGER, stockLocationName NVARCHAR(150) ,serilotType INTEGER,scannedQty INTEGER,  qty INTEGER, shippedQty INTEGER)");
    await db.execute(
        "CREATE TABLE PurchaseOrderDetailScannedItems (recid INTEGER PRIMARY KEY AUTOINCREMENT, ficheNo NVARCHAR(40), orderItemId NVARCHAR(40),productBarcode NVARCHAR(20), warehouse NVARCHAR(40), stockLocationId NVARCHAR(40) ,stockLocationName NVARCHAR(40) ,numberOfPieces INTEGER)");

    await db.execute(
        "CREATE TABLE LocalWaybills (recid INTEGER PRIMARY KEY AUTOINCREMENT,waybillsId NVARCHAR(40), docNo NVARCHAR(40),ficheNo NVARCHAR(40),customerId NVARCHAR(40),customerName NVARCHAR(40),salesmanId NVARCHAR(40), ficheDate INTEGER, shipDate INTEGER, workplaceId NVARCHAR(40), departmentId NVARCHAR(40), warehouseId NVARCHAR(40), warehouseName NVARCHAR(40),transporterId NVARCHAR(40), shippingTypeId NVARCHAR(40), waybillStatusId INTEGER, currencyId INTEGER,totaldiscounted DOUBLE,totalvat DOUBLE,grosstotal DOUBLE,shippingAccountId NVARCHAR(40), shippingAddressId NVARCHAR(40),description NVARCHAR(40))");

    await db.execute(
        "CREATE TABLE LocalWaybillsItem (recid INTEGER PRIMARY KEY AUTOINCREMENT, waybillsId NVARCHAR(40), orderId NVARCHAR(40),  orderItemId NVARCHAR(40),productId NVARCHAR(40), description NVARCHAR(40), warehouseId NVARCHAR(40), warehouseName NVARCHAR(40), stockLocationId NVARCHAR(40) , stockLocationName NVARCHAR(150)  , isProductLocatin INTEGER , productPrice DOUBLE, shippedQty INTEGER,scannedQty INTEGER, qty INTEGER, total DOUBLE, discount DOUBLE, tax DOUBLE, nettotal DOUBLE, unitId NVARCHAR(40), unitConversionId NVARCHAR(40), currencyId INTEGER, barcode NVARCHAR(20), productName NVARCHAR(30),ficheDate INTEGER, erpId NVARCHAR(20), erpCode NVARCHAR(20))");

    await db.execute(
        "CREATE TABLE LocalWaybillsScannedItem (recid INTEGER PRIMARY KEY AUTOINCREMENT, productRecid INTEGER,waybillsId NVARCHAR(40), productId NVARCHAR(40),productBarcode NVARCHAR(20), warehouse NVARCHAR(40) , stockLocationId NVARCHAR(40) ,stockLocationName NVARCHAR(40) , numberOfPieces INTEGER)");

    await db.execute(
        "CREATE TABLE MultiSalesOrder (recid INTEGER PRIMARY KEY AUTOINCREMENT,multiSalesOrder NVARCHAR(40), docNo NVARCHAR(40),ficheNo NVARCHAR(40),customerId NVARCHAR(40),customerName NVARCHAR(40),salesmanId NVARCHAR(40), ficheDate INTEGER, shipDate INTEGER, workplaceId NVARCHAR(40), departmentId NVARCHAR(40), warehouseId NVARCHAR(40), warehouseName NVARCHAR(40),transporterId NVARCHAR(40), shippingTypeId NVARCHAR(40), waybillStatusId INTEGER, currencyId INTEGER,totaldiscounted DOUBLE,totalvat DOUBLE,grosstotal DOUBLE,shippingAccountId NVARCHAR(40), shippingAddressId NVARCHAR(40),description NVARCHAR(40))");

    await db.execute(
        "CREATE TABLE MultiSalesOrderItem (recid INTEGER PRIMARY KEY AUTOINCREMENT, multiSalesOrder NVARCHAR(40), orderId NVARCHAR(40),  orderItemId NVARCHAR(40),productId NVARCHAR(40), description NVARCHAR(40), warehouseId NVARCHAR(40), warehouseName NVARCHAR(40), stockLocationId NVARCHAR(40) , stockLocationName NVARCHAR(150)  , isProductLocatin INTEGER , productPrice DOUBLE, shippedQty INTEGER,scannedQty INTEGER, qty INTEGER, total DOUBLE, discount DOUBLE, tax DOUBLE, nettotal DOUBLE, unitId NVARCHAR(40), unitConversionId NVARCHAR(40), currencyId INTEGER, barcode NVARCHAR(20), productName NVARCHAR(30),ficheDate INTEGER, erpId NVARCHAR(20), erpCode NVARCHAR(20))");

    await db.execute(
        "CREATE TABLE MultiSalesOrderScannedItem (recid INTEGER PRIMARY KEY AUTOINCREMENT, productRecid INTEGER,multiSalesOrder NVARCHAR(40), productId NVARCHAR(40),productBarcode NVARCHAR(20), warehouse NVARCHAR(40) ,stockLocationId NVARCHAR(40) ,stockLocationName NVARCHAR(40) ,numberOfPieces INTEGER)");

    await db.execute(
        "CREATE TABLE ProductBarcodes (recid INTEGER PRIMARY KEY AUTOINCREMENT, orderId NVARCHAR(40),productId NVARCHAR(40),barcode NVARCHAR(40),code NVARCHAR(40),convParam1 INTEGER, convParam2 INTEGER)");
  }

  Future<String> findDatabasePath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'Gns.db');
  }

  Future<int> addProductBarcode(ProductBarcodesItemLocal item) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO ProductBarcodes(orderId, productId,barcode, code,convParam1, convParam2) VALUES(?,?,?,?,?,?)',
        [
          item.orderId,
          item.productId,
          item.barcode,
          item.code,
          item.convParam1,
          item.convParam2,
        ]);

    return inserted;
  }

  Future<List<ProductBarcodesItemLocal>?> getProductBarcodes(
      String orderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db
        .query("ProductBarcodes", where: "orderId = ?", whereArgs: [orderId]);

    var headers = List.generate(maps.length, (i) {
      return ProductBarcodesItemLocal(
        recid: maps[i]['recid'],
        orderId: maps[i]['orderId'],
        productId: maps[i]['productId'],
        barcode: maps[i]['barcode'],
        code: maps[i]['code'],
        convParam1: maps[i]['convParam1'],
        convParam2: maps[i]['convParam2'],
      );
    }).toList();

    return headers;
  }

  Future<int> clearAllProductBarcodes(String orderId) async {
    Database db = await instance.database;
    return await db.delete("ProductBarcodes",
        where: "orderId  = ? ", whereArgs: [orderId]);
  }

  Future<ProductBarcodesItemLocal?> getProductBarcode(
      String orderId, String barcode) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "ProductBarcodes",
      where: "orderId = ? AND barcode = ?",
      whereArgs: [orderId, barcode],
    );

    if (maps.isNotEmpty) {
      return ProductBarcodesItemLocal(
        recid: maps[0]['recid'],
        orderId: maps[0]['orderId'],
        productId: maps[0]['productId'],
        barcode: maps[0]['barcode'],
        code: maps[0]['code'],
        convParam1: maps[0]['convParam1'],
        convParam2: maps[0]['convParam2'],
      );
    } else {
      return null;
    }
  }

  Future<int> addOrderDetailScannedItem(
      String ficheNo,
      String productBarcode,
      int numberOfPieces,
      String orderItemId,
      String stockLocationId,
      String stockLocationName,
      String warehouse) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO OrderDetailScannedItems(ficheNo, orderItemId,productBarcode, warehouse, stockLocationId ,stockLocationName, numberOfPieces) VALUES(?,?,?,?,?,?,?)',
        [
          ficheNo,
          orderItemId,
          productBarcode,
          warehouse,
          stockLocationId,
          stockLocationName,
          numberOfPieces,
        ]);

    return inserted;
  }

  // Future<List<OrderDetailScannedItemDB>?> getOrderDetailScannedItem(
  //     String ficheNo, String orderItemId, String warehouse) async {
  //   Database? db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //       "OrderDetailScannedItems",
  //       where: "ficheNo = ? AND orderItemId = ? AND warehouse = ?",
  //       whereArgs: [ficheNo, orderItemId, warehouse]);

  //   var headers = List.generate(maps.length, (i) {
  //     return OrderDetailScannedItemDB(
  //       recid: maps[i]["recid"],
  //       ficheNo: maps[i]["ficheNo"],
  //       orderItemId: maps[i]["orderItemId"],
  //       productBarcode: maps[i]["productBarcode"],
  //       warehouse: maps[i]["warehouse"],
  //       numberOfPieces: maps[i]["numberOfPieces"],
  //     );
  //   }).toList();

  //   return headers;
  // }

  Future<List<OrderDetailScannedItemDB>?> getOrderDetailScannedItem(
      String ficheNo, String orderItemId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "OrderDetailScannedItems",
        where: "ficheNo = ? AND orderItemId = ? ",
        whereArgs: [ficheNo, orderItemId]);

    var headers = List.generate(maps.length, (i) {
      return OrderDetailScannedItemDB(
        recid: maps[i]["recid"],
        ficheNo: maps[i]["ficheNo"],
        orderItemId: maps[i]["orderItemId"],
        productBarcode: maps[i]["productBarcode"],
        warehouse: maps[i]["warehouse"],
        stockLocationId: maps[i]["stockLocationId"],
        stockLocationName: maps[i]["stockLocationName"],
        numberOfPieces: maps[i]["numberOfPieces"],
      );
    }).toList();

    return headers;
  }

  Future<int> clearAllOrderDetailScannedItems(
      String ficheNo, String orderItemId) async {
    Database db = await instance.database;
    return await db.delete("OrderDetailScannedItems",
        where: "ficheNo  = ? AND orderItemId = ?",
        whereArgs: [ficheNo, orderItemId]);
  }

  Future<int> removeOrderDetailScannedItems(String ficheNo) async {
    Database db = await instance.database;
    return await db.delete("OrderDetailScannedItems",
        where: "ficheNo = ?", whereArgs: [ficheNo]);
  }

  Future<int> clearOrderDetailScannedItem(
      int recid, String ficheNo, String orderItemId) async {
    Database db = await instance.database;
    return await db.delete("OrderDetailScannedItems",
        where: "ficheNo  = ? AND orderItemId = ? AND recid = ?",
        whereArgs: [ficheNo, orderItemId, recid]);
  }

  Future<List<OrderDetailItemDB>?> getOrderDetailItemList(
      String orderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "OrderHeaderDetailItems",
        where: "orderId = ?",
        whereArgs: [orderId]);

    var headers = List.generate(maps.length, (i) {
      return OrderDetailItemDB(
        orderId: maps[i]["orderId"],
        orderItemId: maps[i]["orderItemId"],
        productId: maps[i]["productId"],
        warehouseId: maps[i]["warehouseId"],
        stockLocationId: maps[i]["stockLocationId"],
        ficheNo: maps[i]["ficheNo"],
        productName: maps[i]["productName"],
        productBarcode: maps[i]["productBarcode"],
        warehouse: maps[i]["warehouse"],
        isProductLocatin: maps[i]["isProductLocatin"] == 1 ? true : false,
        isExceededStockCount:
            maps[i]["isExceededStockCount"] == 1 ? true : false,
        stockLocationName: maps[i]["stockLocationName"],
        serilotType: maps[i]["serilotType"],
        scannedQty: maps[i]["scannedQty"],
        qty: maps[i]["qty"],
        shippedQty: maps[i]["shippedQty"],
      );
    }).toList();

    return headers;
  }

  Future<OrderDetailItemDB?> getOrderDetailItem(
      String ficheNo, String orderItemId, String warehouse) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "OrderHeaderDetailItems",
      where: "ficheNo = ? AND orderItemId = ? AND warehouse = ?",
      whereArgs: [ficheNo, orderItemId, warehouse],
    );

    if (maps.isNotEmpty) {
      return OrderDetailItemDB(
        orderId: maps[0]["orderId"],
        orderItemId: maps[0]["orderItemId"],
        productId: maps[0]["productId"],
        warehouseId: maps[0]["warehouseId"],
        stockLocationId: maps[0]["stockLocationId"],
        ficheNo: maps[0]["ficheNo"],
        productName: maps[0]["productName"],
        productBarcode: maps[0]["productBarcode"],
        warehouse: maps[0]["warehouse"],
        isProductLocatin: maps[0]["isProductLocatin"] == 1 ? true : false,
        isExceededStockCount:
            maps[0]["isExceededStockCount"] == 1 ? true : false,
        stockLocationName: maps[0]["stockLocationName"],
        serilotType: maps[0]["serilotType"],
        scannedQty: maps[0]["scannedQty"],
        qty: maps[0]["qty"],
        shippedQty: maps[0]["shippedQty"],
      );
    } else {
      return null;
    }
  }

  Future<int> addOrderDetailItem(OrderDetailItemDB item) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO OrderHeaderDetailItems(orderId, orderItemId, productId, warehouseId, stockLocationId, ficheNo, productName, productBarcode, warehouse, isProductLocatin, isExceededStockCount, stockLocationName, serilotType,scannedQty,qty,shippedQty) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          item.orderId,
          item.orderItemId,
          item.productId,
          item.warehouseId,
          item.stockLocationId,
          item.ficheNo,
          item.productName,
          item.productBarcode,
          item.warehouse,
          item.isProductLocatin == true ? 1 : 0,
          item.isExceededStockCount == true ? 1 : 0,
          item.stockLocationName,
          item.serilotType,
          item.scannedQty,
          item.qty,
          item.shippedQty,
        ]);

    return inserted;
  }

  Future<void> updateOrderLocationArea(
      String stockLocationId,
      String stockLocationName,
      String orderId,
      String orderItemId,
      String warehouse) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'stockLocationId': stockLocationId,
      'stockLocationName': stockLocationName,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeaderDetailItems",
      newData,
      where:
          'orderId = ? AND orderItemId = ? AND warehouse = ?', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [orderId, orderItemId, warehouse],
    );
  }

  Future<int> deleteOrderDetailItem(
      String orderId, String orderItemId, String warehouseId) async {
    Database db = await instance.database;
    return await db.delete("OrderHeaderDetailItems",
        where: "orderId  = ? AND orderItemId = ? AND warehouseId = ?",
        whereArgs: [orderId, orderItemId, warehouseId]);
  }

  Future<void> updateOrderDetailItemQty(
      String orderId, String orderItemId, String warehouseId, int qty) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'qty': qty,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeaderDetailItems",
      newData,
      where: 'orderId = ? AND orderItemId = ? AND warehouseId = ? ',
      whereArgs: [orderId, orderItemId, warehouseId],
    );
  }

  Future<void> updateOrderDetailItemShippedQty(String orderId,
      String orderItemId, String warehouseId, int shippedQty) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'shippedQty': shippedQty,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeaderDetailItems",
      newData,
      where: 'orderId = ? AND orderItemId = ? AND warehouseId = ? ',
      whereArgs: [orderId, orderItemId, warehouseId],
    );
  }

  Future<void> updateOrderDetailItemWarehouse(String orderId,
      String orderItemId, String warehouseId, String warehouse) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'warehouseId': warehouseId,
      'warehouse': warehouse,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeaderDetailItems",
      newData,
      where:
          'orderId = ? AND orderItemId = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [orderId, orderItemId],
    );
  }

  Future<void> updateOrderDetailItemExceededStockCount(
      String orderId, String orderItemId, bool isExceededStockCount) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'isExceededStockCount': isExceededStockCount ? 1 : 0,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeaderDetailItems",
      newData,
      where:
          'orderId = ? AND orderItemId = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [orderId, orderItemId],
    );
  }

  Future<int> clearAllOrderDetailItems(String orderId) async {
    Database db = await instance.database;
    return await db.delete("OrderHeaderDetailItems",
        where: "orderId  = ?", whereArgs: [orderId]);
  }

  Future<void> updateOrderDetailItemScannedQty(int scannedQty, String ficheNo,
      String orderItemId, String warehouse) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'scannedQty': scannedQty,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeaderDetailItems",
      newData,
      where:
          'ficheNo = ? AND orderItemId = ? AND warehouse = ?', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [ficheNo, orderItemId, warehouse],
    );
  }

  //purchase order için barkod db methodları
  Future<int> addPurchaseOrderDetailScannedItem(
      String ficheNo,
      String productBarcode,
      int numberOfPieces,
      String orderItemId,
      String stockLocationId,
      String stockLocationName,
      String warehouse) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO PurchaseOrderDetailScannedItems(ficheNo, orderItemId,productBarcode, warehouse,stockLocationId,stockLocationName,numberOfPieces) VALUES(?,?,?,?,?,?,?)',
        [
          ficheNo,
          orderItemId,
          productBarcode,
          warehouse,
          stockLocationId,
          stockLocationName,
          numberOfPieces,
        ]);

    return inserted;
  }

  // Future<List<PurchaseOrderDetailScannedItemDB>?>
  //     getPurchaseOrderDetailScannedItem(
  //         String ficheNo, String orderItemId, String warehouse) async {
  //   Database? db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //       "PurchaseOrderDetailScannedItems",
  //       where: "ficheNo = ? AND orderItemId = ? AND warehouse = ?",
  //       whereArgs: [ficheNo, orderItemId, warehouse]);

  //   var headers = List.generate(maps.length, (i) {
  //     return PurchaseOrderDetailScannedItemDB(
  //       recid: maps[i]["recid"],
  //       ficheNo: maps[i]["ficheNo"],
  //       orderItemId: maps[i]["orderItemId"],
  //       productBarcode: maps[i]["productBarcode"],
  //       warehouse: maps[i]["warehouse"],
  //       numberOfPieces: maps[i]["numberOfPieces"],
  //     );
  //   }).toList();

  //   return headers;
  // }

  Future<List<PurchaseOrderDetailScannedItemDB>?>
      getPurchaseOrderDetailScannedItem(
          String ficheNo, String orderItemId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "PurchaseOrderDetailScannedItems",
        where: "ficheNo = ? AND orderItemId = ?",
        whereArgs: [ficheNo, orderItemId]);

    var headers = List.generate(maps.length, (i) {
      return PurchaseOrderDetailScannedItemDB(
        recid: maps[i]["recid"],
        ficheNo: maps[i]["ficheNo"],
        orderItemId: maps[i]["orderItemId"],
        productBarcode: maps[i]["productBarcode"],
        warehouse: maps[i]["warehouse"],
        stockLocationId: maps[i]["stockLocationId"],
        stockLocationName: maps[i]["stockLocationName"],
        numberOfPieces: maps[i]["numberOfPieces"],
      );
    }).toList();

    return headers;
  }

  Future<int> clearAllPurchaseOrderDetailScannedItems(
      String ficheNo, String orderItemId) async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderDetailScannedItems",
        where: "ficheNo  = ? AND orderItemId = ?",
        whereArgs: [ficheNo, orderItemId]);
  }

  Future<int> removePurchaseOrderDetailScannedItems(String ficheNo) async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderDetailScannedItems",
        where: "ficheNo = ?", whereArgs: [ficheNo]);
  }

  Future<int> clearPurchaseOrderDetailScannedItem(
      int recid, String ficheNo, String orderItemId) async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderDetailScannedItems",
        where: "ficheNo  = ? AND orderItemId = ? AND recid = ?",
        whereArgs: [ficheNo, orderItemId, recid]);
  }

  Future<List<PurchaseOrderDetailItemDB>?> getPurchaseOrderDetailItemList(
      String purchaseOrderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "PurchaseOrderDetailItems",
        where: "purchaseOrderId = ?",
        whereArgs: [purchaseOrderId]);

    var headers = List.generate(maps.length, (i) {
      return PurchaseOrderDetailItemDB(
        purchaseOrderId: maps[i]["purchaseOrderId"],
        orderItemId: maps[i]["orderItemId"],
        productId: maps[i]["productId"],
        warehouseId: maps[i]["warehouseId"],
        stockLocationId: maps[i]["stockLocationId"],
        ficheNo: maps[i]["ficheNo"],
        productName: maps[i]["productName"],
        productBarcode: maps[i]["productBarcode"],
        warehouse: maps[i]["warehouse"],
        isProductLocatin: maps[i]["isProductLocatin"] == 1 ? true : false,
        stockLocationName: maps[i]["stockLocationName"],
        serilotType: maps[i]["serilotType"],
        scannedQty: maps[i]["scannedQty"],
        qty: maps[i]["qty"],
        shippedQty: maps[i]["shippedQty"],
      );
    }).toList();

    return headers;
  }

  Future<PurchaseOrderDetailItemDB?> getPurchaseOrderDetailItem(
      String ficheNo, String orderItemId, String warehouse) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "PurchaseOrderDetailItems",
      where: "ficheNo = ? AND orderItemId = ? AND warehouse = ?",
      whereArgs: [ficheNo, orderItemId, warehouse],
    );

    if (maps.isNotEmpty) {
      return PurchaseOrderDetailItemDB(
        purchaseOrderId: maps[0]["purchaseOrderId"],
        orderItemId: maps[0]["orderItemId"],
        productId: maps[0]["productId"],
        warehouseId: maps[0]["warehouseId"],
        stockLocationId: maps[0]["stockLocationId"],
        ficheNo: maps[0]["ficheNo"],
        productName: maps[0]["productName"],
        productBarcode: maps[0]["productBarcode"],
        warehouse: maps[0]["warehouse"],
        isProductLocatin: maps[0]["isProductLocatin"] == 1 ? true : false,
        stockLocationName: maps[0]["stockLocationName"],
        serilotType: maps[0]["serilotType"],
        scannedQty: maps[0]["scannedQty"],
        qty: maps[0]["qty"],
        shippedQty: maps[0]["shippedQty"],
      );
    } else {
      return null;
    }
  }

  Future<int> addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB item) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO PurchaseOrderDetailItems(purchaseOrderId, orderItemId, productId, warehouseId, stockLocationId, ficheNo, productName, productBarcode, warehouse, isProductLocatin, stockLocationName, serilotType,scannedQty,qty,shippedQty) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          item.purchaseOrderId,
          item.orderItemId,
          item.productId,
          item.warehouseId,
          item.stockLocationId,
          item.ficheNo,
          item.productName,
          item.productBarcode,
          item.warehouse,
          item.isProductLocatin == true ? 1 : 0,
          item.stockLocationName,
          item.serilotType,
          item.scannedQty,
          item.qty,
          item.shippedQty,
        ]);

    return inserted;
  }

  Future<void> updatePurchaseOrderLocationArea(
      String stockLocationId,
      String stockLocationName,
      String purchaseOrderId,
      String orderItemId,
      String warehouse) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'stockLocationId': stockLocationId,
      'stockLocationName': stockLocationName,
    };
    // Veriyi güncelle
    await db.update(
      "PurchaseOrderDetailItems",
      newData,
      where:
          'purchaseOrderId = ? AND orderItemId = ? AND warehouse = ?', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [purchaseOrderId, orderItemId, warehouse],
    );
  }

  Future<int> deletePurchaseOrderDetailItem(
      String purchaseOrderId, String orderItemId, String warehouseId) async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderDetailItems",
        where: "purchaseOrderId  = ? AND orderItemId = ? AND warehouseId = ?",
        whereArgs: [purchaseOrderId, orderItemId, warehouseId]);
  }

  Future<void> updatePurchaseOrderDetailItemQty(String purchaseOrderId,
      String orderItemId, String warehouseId, int qty) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'qty': qty,
    };
    // Veriyi güncelle
    await db.update(
      "PurchaseOrderDetailItems",
      newData,
      where: 'purchaseOrderId = ? AND orderItemId = ? AND warehouseId = ? ',
      whereArgs: [purchaseOrderId, orderItemId, warehouseId],
    );
  }

  Future<void> updatePurchaseOrderDetailItemShippedQty(String purchaseOrderId,
      String orderItemId, String warehouseId, int shippedQty) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'shippedQty': shippedQty,
    };
    // Veriyi güncelle
    await db.update(
      "PurchaseOrderDetailItems",
      newData,
      where: 'purchaseOrderId = ? AND orderItemId = ? AND warehouseId = ? ',
      whereArgs: [purchaseOrderId, orderItemId, warehouseId],
    );
  }

  Future<void> updatePurchaseOrderDetailItemWarehouse(String purchaseOrderId,
      String orderItemId, String warehouseId, String warehouse) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'warehouseId': warehouseId,
      'warehouse': warehouse,
    };
    // Veriyi güncelle
    await db.update(
      "PurchaseOrderDetailItems",
      newData,
      where:
          'purchaseOrderId = ? AND orderItemId = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [purchaseOrderId, orderItemId],
    );
  }

  Future<int> clearAllPurchaseOrderDetailItems(String purchaseOrderId) async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderDetailItems",
        where: "purchaseOrderId  = ?", whereArgs: [purchaseOrderId]);
  }

  Future<void> updatePurchaseOrderDetailItemScannedQty(int scannedQty,
      String ficheNo, String orderItemId, String warehouse) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'scannedQty': scannedQty,
    };

    await db.update(
      "PurchaseOrderDetailItems",
      newData,
      where: 'ficheNo = ? AND orderItemId = ? AND warehouse = ?',
      whereArgs: [ficheNo, orderItemId, warehouse],
    );
  }

/*
//eski api
  Future<int> addOrderHeader(OrderSummary summary) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO OrderHeader(id, ficheNo, ficheDate, customer, shippingMethod, warehouse, lineCount, orderStatus, totalQty, total, isAssing, assingmentEmail, assingCode, assingmetFullname, isPartialOrder, cancelled ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          summary.id,
          summary.ficheNo,
          summary.ficheDate.millisecondsSinceEpoch,
          summary.customer,
          summary.shippingMethod,
          summary.warehouse,
          summary.lineCount,
          summary.orderStatus,
          summary.totalQty,
          summary.total,
          summary.isAssing == true ? 1 : 0,
          summary.assingmentEmail,
          summary.assingCode,
          summary.assingmetFullname,
          summary.isPartialOrder == true ? 1 : 0,
          summary.cancelled,
        ]);

    return inserted;
  }
  */
/*
//eski api
  Future<int> addOrderHeaders(List<OrderSummary> summaries) async {
    clearAllOrderHeader();
    summaries.forEach((summary) async {
      if (summary.cancelled == 0) {
        addOrderHeader(summary);
      }
    });
    return 0;
  }
  */
  Future<int> addOrderHeader(OrderSummaryItem summary) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO OrderHeader(id, ficheNo, ficheDate, customer, shippingMethod, warehouse, lineCount, orderStatus, totalQty, total, isAssing, assingmentEmail, assingCode, assingmetFullname, isPartialOrder, cancelled ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          summary.orderId,
          summary.ficheNo,
          summary.ficheDate!.millisecondsSinceEpoch,
          summary.customer,
          summary.shippingMethod,
          summary.warehouse,
          summary.lineCount,
          summary.orderStatus,
          summary.totalQty,
          summary.total,
          summary.isAssing == true ? 1 : 0,
          summary.assingmentEmail,
          summary.assingCode,
          summary.assingmetFullname,
          //summary.isPartialOrder == true ? 1 : 0,
          //summary.cancelled,
          //daha onceden isPartialOrder 1 di
          summary.isPartialOrder == true ? 1 : 0,
          0
        ]);

    return inserted;
  }

  Future<List<OrderSummary>?> getOrderHeaderList() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query("OrderHeader", orderBy: "ficheDate DESC");

    var headers = List.generate(maps.length, (i) {
      return OrderSummary(
        maps[i]["id"],
        maps[i]["ficheNo"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        maps[i]["customer"],
        maps[i]["shippingMethod"],
        maps[i]["warehouse"],
        maps[i]["lineCount"],
        maps[i]["orderStatus"],
        maps[i]["totalQty"],
        maps[i]["total"],
        maps[i]["isAssing"] == 1 ? true : false,
        maps[i]["assingmentEmail"],
        maps[i]["assingCode"],
        maps[i]["assingmetFullname"],
        maps[i]["isPartialOrder"] == 1 ? true : false,
        maps[i]["cancelled"],
      );
    }).toList();

    return headers;
  }

  Future<OrderSummary?> getOrderHeaderById(String orderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "OrderHeader",
      where: "id = ?",
      whereArgs: [orderId],
    );

    if (maps.isNotEmpty) {
      return OrderSummary(
        maps[0]["id"],
        maps[0]["ficheNo"],
        DateTime.fromMillisecondsSinceEpoch(maps[0]["ficheDate"] as int),
        maps[0]["customer"],
        maps[0]["shippingMethod"],
        maps[0]["warehouse"],
        maps[0]["lineCount"],
        maps[0]["orderStatus"],
        maps[0]["totalQty"],
        maps[0]["total"],
        maps[0]["isAssing"] == 1 ? true : false,
        maps[0]["assingmentEmail"],
        maps[0]["assingCode"],
        maps[0]["assingmetFullname"],
        maps[0]["isPartialOrder"] == 1 ? true : false,
        maps[0]["cancelled"],
      );
    } else {
      return null;
    }
  }

  Future<int> addOrderHeaders(List<OrderSummaryItem> summaries) async {
    clearAllOrderHeader();
    summaries.forEach((summary) async {
      /*
      if (summary.cancelled == 0) {
        addOrderHeader(summary);
      }
      */

      addOrderHeader(summary);
    });
    return 0;
  }

  Future<void> updateOrderStatusForOrderHeader(
      String newOrderStatus, String salesOrderId) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'orderStatus': newOrderStatus,
    };
    // Veriyi güncelle
    await db.update(
      "OrderHeader",
      newData,
      where: 'id = ? ',
      whereArgs: [salesOrderId],
    );
  }

  Future<int> updateOrderHeader(OrderHeader header) async {
    Database db = await instance.database;
    return await db.update("OrderHeader", header.toMap(),
        where: "id=?", whereArgs: [header.id]);
  }

  Future<int> removeOrderHeader(String id) async {
    Database db = await instance.database;
    return await db.delete("OrderHeader", where: "id=?", whereArgs: [id]);
  }

  Future<int> getOrderHeaderCount() async {
    Database? db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query("OrderHeader");

    return maps.toList().length;
  }

  Future<int> clearAllOrderHeader() async {
    Database db = await instance.database;
    return await db.delete("OrderHeader");
  }

  Future<List<OrderSummary>> searchOrderHeader(String searchkey) async {
    Database? db = await instance.database;

    List<OrderSummary> summaryList = [];

    final List<Map<String, dynamic>> maps = await db.query("OrderHeader",
        where:
            'ficheNo LIKE ? OR customer LIKE ? OR warehouse LIKE ? OR orderStatus LIKE ? OR assingmetFullname LIKE ?',
        whereArgs: [
          '%$searchkey%',
          '%$searchkey%',
          '%$searchkey%',
          '%$searchkey%',
          '%$searchkey%'
        ],
        orderBy: "ficheDate DESC");

    summaryList = List.generate(maps.length, (i) {
      return OrderSummary(
        maps[i]["id"],
        maps[i]["ficheNo"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        maps[i]["customer"],
        maps[i]["shippingMethod"],
        maps[i]["warehouse"],
        maps[i]["lineCount"],
        maps[i]["orderStatus"],
        maps[i]["totalQty"],
        maps[i]["total"],
        maps[i]["isAssing"] == 1 ? true : false,
        maps[i]["assingmentEmail"],
        maps[i]["assingCode"],
        maps[i]["assingmetFullname"],
        maps[i]["isPartialOrder"] == 1 ? true : false,
        maps[i]["cancelled"],
      );
    }).toList();

    //summaryList = summaryList.where((element) => !element.isAssing).toList();

    return summaryList;
  }

  Future<int> addPurchaseOrderSummary(PurchaseOrderSummaryItem summary) async {
    Database db = await instance.database;

    int inserted = await db.rawInsert(
        'INSERT INTO PurchaseOrderSummary(purchaseOrderId, ficheNo, ficheDate, customer, shippingMethod, warehouse, lineCount, orderStatus, totalQty, total, isAssing, assingmentEmail, assingCode, assingmetFullname, isPartialOrder ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          summary.orderId,
          summary.ficheNo,
          summary.ficheDate!.millisecondsSinceEpoch,
          summary.customer,
          summary.shippingMethod,
          summary.warehouse,
          summary.lineCount,
          summary.orderStatus,
          summary.totalQty,
          summary.total,
          summary.isAssing == true ? 1 : 0,
          summary.assingmentEmail,
          summary.assingCode,
          summary.assingmetFullname,
          summary.isPartialOrder == true ? 1 : 0,
        ]);

    return inserted;
  }

  Future<void> updateOrderStatusForPurchaseOrderHeader(
      String newOrderStatus, String purchaseOrderId) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'orderStatus': newOrderStatus,
    };
    // Veriyi güncelle
    await db.update(
      "PurchaseOrderSummary",
      newData,
      where: 'purchaseOrderId = ? ',
      whereArgs: [purchaseOrderId],
    );
  }

  Future<int> addPurchaseOrderSummarys(
      List<PurchaseOrderSummaryItem> summaries) async {
    clearAllPurchaseOrderSummary();
    summaries.forEach((summary) async {
      /*
      if (summary.cancelled == 0) {
        addOrderHeader(summary);
      }
      */

      addPurchaseOrderSummary(summary);
    });
    return 0;
  }

  Future<int> removePurchaseOrderSummary(String purchaseOrderId) async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderSummary",
        where: "purchaseOrderId=?", whereArgs: [purchaseOrderId]);
  }

  Future<int> getPurchaseOrderSummaryCount() async {
    Database? db = await instance.database;

    final List<Map<String, dynamic>> maps =
        await db.query("PurchaseOrderSummary");

    return maps.toList().length;
  }

  Future<int> clearAllPurchaseOrderSummary() async {
    Database db = await instance.database;
    return await db.delete("PurchaseOrderSummary");
  }

  Future<List<PurchaseOrderSummaryLocal>?> getPurchaseOrderSummaryList() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query("PurchaseOrderSummary", orderBy: "ficheDate DESC");

    var headers = List.generate(maps.length, (i) {
      return PurchaseOrderSummaryLocal(
        maps[i]["purchaseOrderId"],
        maps[i]["ficheNo"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        maps[i]["customer"],
        maps[i]["shippingMethod"],
        maps[i]["warehouse"],
        maps[i]["lineCount"],
        maps[i]["orderStatus"],
        maps[i]["totalQty"],
        maps[i]["total"],
        maps[i]["isAssing"] == 1 ? true : false,
        maps[i]["assingmentEmail"],
        maps[i]["assingCode"],
        maps[i]["assingmetFullname"],
        maps[i]["isPartialOrder"] == 1 ? true : false,
      );
    }).toList();

    return headers;
  }

  Future<PurchaseOrderSummaryLocal?> getPurchaseOrderHeaderById(
      String orderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "PurchaseOrderSummary",
      where: "purchaseOrderId = ?",
      whereArgs: [orderId],
    );

    if (maps.isNotEmpty) {
      return PurchaseOrderSummaryLocal(
        maps[0]["purchaseOrderId"],
        maps[0]["ficheNo"],
        DateTime.fromMillisecondsSinceEpoch(maps[0]["ficheDate"] as int),
        maps[0]["customer"],
        maps[0]["shippingMethod"],
        maps[0]["warehouse"],
        maps[0]["lineCount"],
        maps[0]["orderStatus"],
        maps[0]["totalQty"],
        maps[0]["total"],
        maps[0]["isAssing"] == 1 ? true : false,
        maps[0]["assingmentEmail"],
        maps[0]["assingCode"],
        maps[0]["assingmetFullname"],
        maps[0]["isPartialOrder"] == 1 ? true : false,
      );
    } else {
      return null;
    }
  }

  Future<List<PurchaseOrderSummaryLocal>> searchPurchaseOrderHeader(
      String searchkey) async {
    Database? db = await instance.database;

    List<PurchaseOrderSummaryLocal> purchaseOrderList = [];

    final List<Map<String, dynamic>> maps = await db.query(
        "PurchaseOrderSummary",
        where:
            'ficheNo LIKE ? OR customer LIKE ? OR warehouse LIKE ? OR orderStatus LIKE ? OR assingmetFullname LIKE ?',
        whereArgs: [
          '%$searchkey%',
          '%$searchkey%',
          '%$searchkey%',
          '%$searchkey%',
          '%$searchkey%'
        ],
        orderBy: "ficheDate DESC");

    purchaseOrderList = List.generate(maps.length, (i) {
      return PurchaseOrderSummaryLocal(
        maps[i]["purchaseOrderId"],
        maps[i]["ficheNo"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        maps[i]["customer"],
        maps[i]["shippingMethod"],
        maps[i]["warehouse"],
        maps[i]["lineCount"],
        maps[i]["orderStatus"],
        maps[i]["totalQty"],
        maps[i]["total"],
        maps[i]["isAssing"] == 1 ? true : false,
        maps[i]["assingmentEmail"],
        maps[i]["assingCode"],
        maps[i]["assingmetFullname"],
        maps[i]["isPartialOrder"] == 1 ? true : false,
      );
    }).toList();

    //summaryList = summaryList.where((element) => !element.isAssing).toList();

    return purchaseOrderList;
  }

  Future<int> addMultiPurchaseOrder(WaybillLocalModel waybill) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO LocalWaybills(waybillsId,docNo , ficheNo, customerId, customerName,salesmanId, ficheDate,shipDate,workplaceId,departmentId, warehouseId, warehouseName, transporterId,shippingTypeId, waybillStatusId, currencyId, totaldiscounted,totalvat, grosstotal, shippingAccountId, shippingAddressId, description) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          waybill.waybillsId,
          waybill.docNo,
          waybill.ficheNo,
          waybill.customerId,
          waybill.customerName,
          waybill.salesmanId,
          waybill.ficheDate!.millisecondsSinceEpoch,
          waybill.shipDate!.millisecondsSinceEpoch,
          waybill.workplaceId,
          waybill.departmentId,
          waybill.warehouseId,
          waybill.warehouseName,
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

  Future<int> removeMultiOrder(String waybillsId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybills",
        where: "waybillsId=?", whereArgs: [waybillsId]);
  }

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
        maps[i]["customerName"],
        maps[i]["salesmanId"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        DateTime.fromMillisecondsSinceEpoch(maps[i]["shipDate"] as int),
        maps[i]["workplaceId"],
        maps[i]["departmentId"],
        maps[i]["warehouseId"],
        maps[i]["warehouseName"],
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

  //LocalWaybills olanların hepsi aslında multipurchaseorder
  Future<void> updateMultiPurchaseOrderOrderWarehouse(
      String waybillsId,
      String workplaceId,
      String departmentId,
      String warehouseId,
      String warehouseName) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'workplaceId': workplaceId,
      'departmentId': departmentId,
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
    };
    // Veriyi güncelle
    await db.update(
      "LocalWaybills",
      newData,
      where:
          'waybillsId = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [waybillsId],
    );
  }

  Future<int> addMultiOrderHeaders(List<WaybillLocalModel> summaries) async {
    clearAllMultiOrderHeader();
    summaries.forEach((summary) async {
      addMultiPurchaseOrder(summary);
    });
    return 0;
  }

  Future<int> clearAllMultiOrderHeader() async {
    Database db = await instance.database;
    return await db.delete("LocalWaybills");
  }

//asfasf
  Future<List<WaybillItemLocalModel>?> getWaybillOrderDetailItemList(
      String waybillsId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query("LocalWaybillsItem",
        where: "waybillsId = ?", whereArgs: [waybillsId]);

    var headers = List.generate(maps.length, (i) {
      return WaybillItemLocalModel(
        recid: maps[i]['recid'],
        waybillsId: maps[i]['waybillsId'],
        orderId: maps[i]['orderId'],
        orderItemId: maps[i]['orderItemId'],
        productId: maps[i]['productId'],
        description: maps[i]['description'],
        warehouseId: maps[i]['warehouseId'],
        warehouseName: maps[i]['warehouseName'],
        stockLocationId: maps[i]['stockLocationId'],
        stockLocationName: maps[i]['stockLocationName'],
        isProductLocatin: maps[i]['isProductLocatin'] == 1 ? true : false,
        productPrice: maps[i]['productPrice'],
        shippedQty: maps[i]['shippedQty'],
        scannedQty: maps[i]['scannedQty'],
        qty: maps[i]['qty'],
        total: maps[i]['total'],
        discount: maps[i]['discount'],
        tax: maps[i]['tax'],
        nettotal: maps[i]['nettotal'],
        unitId: maps[i]['unitId'],
        unitConversionId: maps[i]['unitConversionId'],
        currencyId: maps[i]['currencyId'],
        barcode: maps[i]['barcode'],
        productName: maps[i]['productName'],
        ficheDate:
            DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        erpId: maps[i]['erpId'],
        erpCode: maps[i]['erpCode'],
      );
    }).toList();

    return headers;
  }

  Future<WaybillItemLocalModel?> getWaybillOrderDetailItem(
      String waybillsId, String productId, String warehouseId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "LocalWaybillsItem",
      where: "waybillsId = ? AND productId = ? AND warehouseId = ?",
      whereArgs: [waybillsId, productId, warehouseId],
    );

    if (maps.isNotEmpty) {
      return WaybillItemLocalModel(
        recid: maps[0]['recid'],
        waybillsId: maps[0]['waybillsId'],
        orderId: maps[0]['orderId'],
        orderItemId: maps[0]['orderItemId'],
        productId: maps[0]['productId'],
        description: maps[0]['description'],
        warehouseId: maps[0]['warehouseId'],
        warehouseName: maps[0]['warehouseName'],
        stockLocationId: maps[0]['stockLocationId'],
        stockLocationName: maps[0]['stockLocationName'],
        isProductLocatin: maps[0]['isProductLocatin'] == 1 ? true : false,
        productPrice: maps[0]['productPrice'],
        shippedQty: maps[0]['shippedQty'],
        scannedQty: maps[0]['scannedQty'],
        qty: maps[0]['qty'],
        total: maps[0]['total'],
        discount: maps[0]['discount'],
        tax: maps[0]['tax'],
        nettotal: maps[0]['nettotal'],
        unitId: maps[0]['unitId'],
        unitConversionId: maps[0]['unitConversionId'],
        currencyId: maps[0]['currencyId'],
        barcode: maps[0]['barcode'],
        productName: maps[0]['productName'],
        ficheDate:
            DateTime.fromMillisecondsSinceEpoch(maps[0]["ficheDate"] as int),
        erpId: maps[0]['erpId'],
        erpCode: maps[0]['erpCode'],
      );
    } else {
      return null;
    }
  }

  Future<int> addWaybillOrderDetailItem(WaybillItemLocalModel item) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO LocalWaybillsItem(waybillsId, orderId, orderItemId, productId, description, warehouseId, warehouseName,stockLocationId, stockLocationName, isProductLocatin, productPrice, shippedQty, scannedQty, qty, total, discount, tax, nettotal, unitId, unitConversionId, currencyId, barcode, productName, ficheDate,erpId, erpCode) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          item.waybillsId,
          item.orderId,
          item.orderItemId,
          item.productId,
          item.description,
          item.warehouseId,
          item.warehouseName,
          item.stockLocationId,
          item.stockLocationName,
          item.isProductLocatin == true ? 1 : 0,
          item.productPrice,
          item.shippedQty,
          item.scannedQty,
          item.qty,
          item.total,
          item.discount,
          item.tax,
          item.nettotal,
          item.unitId,
          item.unitConversionId,
          item.currencyId,
          item.barcode,
          item.productName,
          item.ficheDate!.millisecondsSinceEpoch,
          item.erpId,
          item.erpCode,
        ]);

    return inserted;
  }

  Future<void> updateWaybillDetailItemQty(String waybillsId, String orderId,
      String orderItemId, String warehouseId, int qty) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'qty': qty,
    };
    // Veriyi güncelle
    await db.update(
      "LocalWaybillsItem",
      newData,
      where:
          'waybillsId = ? AND orderId = ? AND orderItemId = ? AND warehouseId = ? ',
      whereArgs: [waybillsId, orderId, orderItemId, warehouseId],
    );
  }

  Future<void> updateWaybillDetailItemWarehouse(String waybillsId,
      String orderItemId, String warehouseId, String warehouseName) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
    };
    // Veriyi güncelle
    await db.update(
      "LocalWaybillsItem",
      newData,
      where:
          'waybillsId = ? AND orderItemId = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [waybillsId, orderItemId],
    );
  }

  Future<int> clearAllWaybillOrderDetailItems(String waybillsId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybillsItem",
        where: "waybillsId  = ?", whereArgs: [waybillsId]);
  }

  Future<bool?> isThereAnyItemBasedOrderIdInMultiPurchaseOrder(
      String orderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "LocalWaybillsItem",
      where: "orderId = ?",
      whereArgs: [orderId],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> deleteWaybillDetailItem(String waybillsId, String orderId,
      String orderItemId, String warehouseId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybillsItem",
        where:
            "waybillsId = ? AND orderId  = ? AND orderItemId = ? AND warehouseId = ?",
        whereArgs: [waybillsId, orderId, orderItemId, warehouseId]);
  }

//sdfsdfsdf
  Future<void> updateWaybillOrderDetailItemScannedQty(
      int scannedQty,
      int productRecid,
      String waybillsId,
      String productId,
      String warehouseId) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'scannedQty': scannedQty,
    };
    // Veriyi güncelle
    await db.update(
      "LocalWaybillsItem",
      newData,
      where:
          'recid = ? AND waybillsId = ? AND productId = ? AND warehouseId = ?', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [productRecid, waybillsId, productId, warehouseId],
    );
  }

  Future<int> addWaybillOrderScannedItem(
      int productRecid,
      String waybillsId,
      String productBarcode,
      int numberOfPieces,
      String productId,
      String stockLocationId,
      String stockLocationName,
      String warehouse) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO LocalWaybillsScannedItem(productRecid, waybillsId, productId,productBarcode, warehouse, stockLocationId, stockLocationName, numberOfPieces) VALUES(?,?,?,?,?,?,?,?)',
        [
          productRecid,
          waybillsId,
          productId,
          productBarcode,
          warehouse,
          stockLocationId,
          stockLocationName,
          numberOfPieces,
        ]);

    return inserted;
  }

  // Future<List<WaybillScannedItemDB>?> getWaybillOrderScannedItem(
  //     int productRecid,
  //     String waybillsId,
  //     String productId,
  //     String warehouse) async {
  //   Database? db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //       "LocalWaybillsScannedItem",
  //       where:
  //           "productRecid = ? AND waybillsId = ? AND productId = ? AND warehouse = ?",
  //       whereArgs: [productRecid, waybillsId, productId, warehouse]);

  //   var headers = List.generate(maps.length, (i) {
  //     return WaybillScannedItemDB(
  //       recid: maps[i]["recid"],
  //       waybillsId: maps[i]["waybillsId"],
  //       productId: maps[i]["productId"],
  //       productBarcode: maps[i]["productBarcode"],
  //       warehouse: maps[i]["warehouse"],
  //       numberOfPieces: maps[i]["numberOfPieces"],
  //     );
  //   }).toList();

  //   return headers;
  // }

  Future<List<WaybillScannedItemDB>?> getWaybillOrderScannedItem(
      int productRecid, String waybillsId, String productId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "LocalWaybillsScannedItem",
        where: "productRecid = ? AND waybillsId = ? AND productId = ?",
        whereArgs: [productRecid, waybillsId, productId]);

    var headers = List.generate(maps.length, (i) {
      return WaybillScannedItemDB(
        recid: maps[i]["recid"],
        waybillsId: maps[i]["waybillsId"],
        productId: maps[i]["productId"],
        productBarcode: maps[i]["productBarcode"],
        warehouse: maps[i]["warehouse"],
        stockLocationId: maps[i]["stockLocationId"],
        stockLocationName: maps[i]["stockLocationName"],
        numberOfPieces: maps[i]["numberOfPieces"],
      );
    }).toList();

    return headers;
  }

  Future<int> clearAllWaybillOrderScannedItems(
      int productRecid, String waybillsId, String productId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybillsScannedItem",
        where: "productRecid = ? AND waybillsId  = ? AND productId = ?",
        whereArgs: [productRecid, waybillsId, productId]);
  }

  Future<int> removeWaybillOrderScannedItems(String waybillsId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybillsScannedItem",
        where: "waybillsId = ?", whereArgs: [waybillsId]);
  }

  Future<int> clearWaybillOrderScannedItem(
      int recid, String waybillsId, String productId) async {
    Database db = await instance.database;
    return await db.delete("LocalWaybillsScannedItem",
        where: "waybillsId  = ? AND productId = ? AND recid = ?",
        whereArgs: [waybillsId, productId, recid]);
  }

  //multi sales

  Future<int> addMultiSalesOrder(WaybillLocalModel waybill) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO MultiSalesOrder(multiSalesOrder,docNo , ficheNo, customerId, customerName,salesmanId, ficheDate,shipDate,workplaceId,departmentId, warehouseId, warehouseName, transporterId,shippingTypeId, waybillStatusId, currencyId, totaldiscounted,totalvat, grosstotal, shippingAccountId, shippingAddressId, description) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          waybill.waybillsId,
          waybill.docNo,
          waybill.ficheNo,
          waybill.customerId,
          waybill.customerName,
          waybill.salesmanId,
          waybill.ficheDate!.millisecondsSinceEpoch,
          waybill.shipDate!.millisecondsSinceEpoch,
          waybill.workplaceId,
          waybill.departmentId,
          waybill.warehouseId,
          waybill.warehouseName,
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

  Future<int> removeMultiSalesOrder(String multiSalesOrder) async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrder",
        where: "multiSalesOrder=?", whereArgs: [multiSalesOrder]);
  }

  Future<List<WaybillLocalModel>?> getMultiSalesOrderHeaderList() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query("MultiSalesOrder", orderBy: "ficheDate DESC");

    var headers = List.generate(maps.length, (i) {
      return WaybillLocalModel(
        maps[i]["multiSalesOrder"],
        maps[i]["docNo"],
        maps[i]["ficheNo"],
        maps[i]["customerId"],
        maps[i]["customerName"],
        maps[i]["salesmanId"],
        DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        DateTime.fromMillisecondsSinceEpoch(maps[i]["shipDate"] as int),
        maps[i]["workplaceId"],
        maps[i]["departmentId"],
        maps[i]["warehouseId"],
        maps[i]["warehouseName"],
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

  Future<void> updateMultiSalesOrderWarehouse(
      String multiSalesOrder,
      String workplaceId,
      String departmentId,
      String warehouseId,
      String warehouseName) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'workplaceId': workplaceId,
      'departmentId': departmentId,
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
    };
    // Veriyi güncelle
    await db.update(
      "MultiSalesOrder",
      newData,
      where:
          'multiSalesOrder = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [multiSalesOrder],
    );
  }

  Future<int> addMultiSalesOrderHeaders(
      List<WaybillLocalModel> summaries) async {
    clearAllMultiOrderHeader();
    summaries.forEach((summary) async {
      addMultiPurchaseOrder(summary);
    });
    return 0;
  }

  Future<int> clearAllMultiSalesOrderHeader() async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrder");
  }

//asfasf
  Future<List<WaybillItemLocalModel>?> getMultiSalesOrderDetailItemList(
      String multiSalesOrder) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "MultiSalesOrderItem",
        where: "multiSalesOrder = ?",
        whereArgs: [multiSalesOrder]);

    var headers = List.generate(maps.length, (i) {
      return WaybillItemLocalModel(
        recid: maps[i]['recid'],
        waybillsId: maps[i]['multiSalesOrder'],
        orderId: maps[i]['orderId'],
        orderItemId: maps[i]['orderItemId'],
        productId: maps[i]['productId'],
        description: maps[i]['description'],
        warehouseId: maps[i]['warehouseId'],
        warehouseName: maps[i]['warehouseName'],
        stockLocationId: maps[i]['stockLocationId'],
        stockLocationName: maps[i]['stockLocationName'],
        isProductLocatin: maps[i]['isProductLocatin'] == 1 ? true : false,
        productPrice: maps[i]['productPrice'],
        shippedQty: maps[i]['shippedQty'],
        scannedQty: maps[i]['scannedQty'],
        qty: maps[i]['qty'],
        total: maps[i]['total'],
        discount: maps[i]['discount'],
        tax: maps[i]['tax'],
        nettotal: maps[i]['nettotal'],
        unitId: maps[i]['unitId'],
        unitConversionId: maps[i]['unitConversionId'],
        currencyId: maps[i]['currencyId'],
        barcode: maps[i]['barcode'],
        productName: maps[i]['productName'],
        ficheDate:
            DateTime.fromMillisecondsSinceEpoch(maps[i]["ficheDate"] as int),
        erpId: maps[i]['erpId'],
        erpCode: maps[i]['erpCode'],
      );
    }).toList();

    return headers;
  }

  Future<WaybillItemLocalModel?> getMultiSalesOrderDetailItem(
      String multiSalesOrder, String productId, String warehouseId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "MultiSalesOrderItem",
      where: "multiSalesOrder = ? AND productId = ? AND warehouseId = ?",
      whereArgs: [multiSalesOrder, productId, warehouseId],
    );

    if (maps.isNotEmpty) {
      return WaybillItemLocalModel(
        recid: maps[0]['recid'],
        waybillsId: maps[0]['multiSalesOrder'],
        orderId: maps[0]['orderId'],
        orderItemId: maps[0]['orderItemId'],
        productId: maps[0]['productId'],
        description: maps[0]['description'],
        warehouseId: maps[0]['warehouseId'],
        warehouseName: maps[0]['warehouseName'],
        stockLocationId: maps[0]['stockLocationId'],
        stockLocationName: maps[0]['stockLocationName'],
        isProductLocatin: maps[0]['isProductLocatin'] == 1 ? true : false,
        productPrice: maps[0]['productPrice'],
        shippedQty: maps[0]['shippedQty'],
        scannedQty: maps[0]['scannedQty'],
        qty: maps[0]['qty'],
        total: maps[0]['total'],
        discount: maps[0]['discount'],
        tax: maps[0]['tax'],
        nettotal: maps[0]['nettotal'],
        unitId: maps[0]['unitId'],
        unitConversionId: maps[0]['unitConversionId'],
        currencyId: maps[0]['currencyId'],
        barcode: maps[0]['barcode'],
        productName: maps[0]['productName'],
        ficheDate:
            DateTime.fromMillisecondsSinceEpoch(maps[0]["ficheDate"] as int),
        erpId: maps[0]['erpId'],
        erpCode: maps[0]['erpCode'],
      );
    } else {
      return null;
    }
  }

  Future<int> addMultiSalesOrderDetailItem(WaybillItemLocalModel item) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO MultiSalesOrderItem(multiSalesOrder, orderId, orderItemId, productId, description, warehouseId, warehouseName,stockLocationId, stockLocationName, isProductLocatin, productPrice, shippedQty, scannedQty, qty, total, discount, tax, nettotal, unitId, unitConversionId, currencyId, barcode, productName, ficheDate,erpId, erpCode) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          item.waybillsId,
          item.orderId,
          item.orderItemId,
          item.productId,
          item.description,
          item.warehouseId,
          item.warehouseName,
          item.stockLocationId,
          item.stockLocationName,
          item.isProductLocatin == true ? 1 : 0,
          item.productPrice,
          item.shippedQty,
          item.scannedQty,
          item.qty,
          item.total,
          item.discount,
          item.tax,
          item.nettotal,
          item.unitId,
          item.unitConversionId,
          item.currencyId,
          item.barcode,
          item.productName,
          item.ficheDate!.millisecondsSinceEpoch,
          item.erpId,
          item.erpCode,
        ]);

    return inserted;
  }

  Future<void> updateMultiSalesDetailItemQty(String multiSalesOrder,
      String orderId, String orderItemId, String warehouseId, int qty) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'qty': qty,
    };
    // Veriyi güncelle
    await db.update(
      "MultiSalesOrderItem",
      newData,
      where:
          'multiSalesOrder = ? AND orderId = ? AND orderItemId = ? AND warehouseId = ? ',
      whereArgs: [multiSalesOrder, orderId, orderItemId, warehouseId],
    );
  }

  Future<void> updateMultiSalesDetailItemWarehouse(String multiSalesOrder,
      String orderItemId, String warehouseId, String warehouseName) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
    };
    // Veriyi güncelle
    await db.update(
      "MultiSalesOrderItem",
      newData,
      where:
          'multiSalesOrder = ? AND orderItemId = ? ', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [multiSalesOrder, orderItemId],
    );
  }

  Future<int> clearAllMultiSalesOrderDetailItems(String multiSalesOrder) async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrderItem",
        where: "multiSalesOrder  = ?", whereArgs: [multiSalesOrder]);
  }

  Future<bool?> isThereAnyItemBasedOrderIdInMultiSalesOrder(
      String orderId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "MultiSalesOrderItem",
      where: "orderId = ?",
      whereArgs: [orderId],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> deleteMultiSalesDetailItem(String multiSalesOrder, String orderId,
      String orderItemId, String warehouseId) async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrderItem",
        where:
            "multiSalesOrder = ? AND orderId  = ? AND orderItemId = ? AND warehouseId = ?",
        whereArgs: [multiSalesOrder, orderId, orderItemId, warehouseId]);
  }

//sdfsdfsdf
  Future<void> updateMultiSalesOrderDetailItemScannedQty(
      int scannedQty,
      int productRecid,
      String multiSalesOrder,
      String productId,
      String warehouseId) async {
    Database db = await instance.database;
    Map<String, dynamic> newData = {
      'scannedQty': scannedQty,
    };
    // Veriyi güncelle
    await db.update(
      "MultiSalesOrderItem",
      newData,
      where:
          'recid = ? AND multiSalesOrder = ? AND productId = ? AND warehouseId = ?', // Güncellenecek satırı belirtmek için bir koşul sağlayın
      whereArgs: [productRecid, multiSalesOrder, productId, warehouseId],
    );
  }

  Future<int> addMultiSalesOrderScannedItem(
      int productRecid,
      String multiSalesOrder,
      String productBarcode,
      int numberOfPieces,
      String productId,
      String stockLocationId,
      String stockLocationName,
      String warehouse) async {
    Database db = await instance.database;

    //await removeOrderHeader(summary.id);

    int inserted = await db.rawInsert(
        'INSERT INTO MultiSalesOrderScannedItem(productRecid, multiSalesOrder, productId,productBarcode, warehouse, stockLocationId, stockLocationName, numberOfPieces) VALUES(?,?,?,?,?,?,?,?)',
        [
          productRecid,
          multiSalesOrder,
          productId,
          productBarcode,
          warehouse,
          stockLocationId,
          stockLocationName,
          numberOfPieces,
        ]);

    return inserted;
  }

  // Future<List<WaybillScannedItemDB>?> getMultiSalesOrderScannedItem(
  //     int productRecid,
  //     String multiSalesOrder,
  //     String productId,
  //     String warehouse) async {
  //   Database? db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //       "MultiSalesOrderScannedItem",
  //       where:
  //           "productRecid = ? AND multiSalesOrder = ? AND productId = ? AND warehouse = ?",
  //       whereArgs: [productRecid, multiSalesOrder, productId, warehouse]);

  //   var headers = List.generate(maps.length, (i) {
  //     return WaybillScannedItemDB(
  //       recid: maps[i]["recid"],
  //       waybillsId: maps[i]["multiSalesOrder"],
  //       productId: maps[i]["productId"],
  //       productBarcode: maps[i]["productBarcode"],
  //       warehouse: maps[i]["warehouse"],
  //       numberOfPieces: maps[i]["numberOfPieces"],
  //     );
  //   }).toList();

  //   return headers;
  // }

  Future<List<WaybillScannedItemDB>?> getMultiSalesOrderScannedItem(
      int productRecid, String multiSalesOrder, String productId) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        "MultiSalesOrderScannedItem",
        where: "productRecid = ? AND multiSalesOrder = ? AND productId = ?",
        whereArgs: [productRecid, multiSalesOrder, productId]);

    var headers = List.generate(maps.length, (i) {
      return WaybillScannedItemDB(
        recid: maps[i]["recid"],
        waybillsId: maps[i]["multiSalesOrder"],
        productId: maps[i]["productId"],
        productBarcode: maps[i]["productBarcode"],
        warehouse: maps[i]["warehouse"],
        stockLocationId: maps[i]["stockLocationId"],
        stockLocationName: maps[i]["stockLocationName"],
        numberOfPieces: maps[i]["numberOfPieces"],
      );
    }).toList();

    return headers;
  }

  Future<int> clearAllMultiSalesOrderScannedItems(
      int productRecid, String multiSalesOrder, String productId) async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrderScannedItem",
        where: "productRecid = ? AND multiSalesOrder  = ? AND productId = ?",
        whereArgs: [productRecid, multiSalesOrder, productId]);
  }

  Future<int> removeMultiSalesOrderScannedItems(String multiSalesOrder) async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrderScannedItem",
        where: "multiSalesOrder = ?", whereArgs: [multiSalesOrder]);
  }

  Future<int> clearMultiSalesOrderScannedItem(
      int recid, String multiSalesOrder, String productId) async {
    Database db = await instance.database;
    return await db.delete("MultiSalesOrderScannedItem",
        where: "multiSalesOrder  = ? AND productId = ? AND recid = ?",
        whereArgs: [multiSalesOrder, productId, recid]);
  }
  //multi sales

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> clearAllDatabase() async {
    Database db = await instance.database;
    await db.delete("OrderHeader");
    await db.delete("OrderHeaderDetailItems");
    await db.delete("OrderDetailScannedItems");
    await db.delete("ProcessHistory");
    await db.delete("PurchaseOrderSummary");
    await db.delete("PurchaseOrderDetailItems");
    await db.delete("PurchaseOrderDetailScannedItems");
    await db.delete("LocalWaybills");
    await db.delete("LocalWaybillsItem");
    await db.delete("LocalWaybillsScannedItem");
    await db.delete("MultiSalesOrder");
    await db.delete("MultiSalesOrderItem");
    await db.delete("MultiSalesOrderScannedItem");
    await db.delete("ProductBarcodes");
  }
}
