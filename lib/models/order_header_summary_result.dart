import 'order_summary.dart';

class OrderSummaryResult {
  List<OrderSummary>? data;
  int totalCount = 0;
  int page = 1;
  int limit = 100;
  bool hasNextPage = false;
  int next = 0;
  int prev = 0;

  OrderSummaryResult({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.limit,
    required this.hasNextPage,
    required this.next,
    required this.prev,
  });

  OrderSummaryResult.fromJson(Map<String, dynamic> json) {
    List<OrderSummary> subItems = [];
    if (json['data'] != null) {
      json['data'].forEach((row) {
        subItems.add(OrderSummary.fromJson(row));
      });
    }

    data = subItems;
    totalCount = json['totalCount']?.toInt();
    page = json['page']?.toInt();
    limit = json['limit']?.toInt();
    hasNextPage = json['hasNextPage'];
    next = json['next']?.toInt();
    prev = json['prev']?.toInt();
  }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   if (this.data != null) {
  //     final v = this.data;
  //     final arr0 = [];
  //     v.forEach((v) {
  //       arr0.add(v.toMap());
  //     });
  //     data['data'] = arr0;
  //   }
  //   data['totalCount'] = totalCount;
  //   data['page'] = page;
  //   data['limit'] = limit;
  //   data['hasNextPage'] = hasNextPage;
  //   data['next'] = next;
  //   data['prev'] = prev;
  //   return data;
  // }
}
