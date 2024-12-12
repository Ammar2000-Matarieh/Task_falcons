import 'package:task_falcons/models/quantity/sales_man_items_balance.dart';

class QuantityModel {
  List<SalesManItemsBalance>? salesManItemsBalance;

  QuantityModel({
    this.salesManItemsBalance,
  });

  QuantityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json['SalesMan_Items_Balance'] != null) {
      salesManItemsBalance = <SalesManItemsBalance>[];
      json['SalesMan_Items_Balance'].forEach(
        (v) {
          salesManItemsBalance!.add(
            SalesManItemsBalance.fromJson(
              v,
            ),
          );
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salesManItemsBalance != null) {
      data['SalesMan_Items_Balance'] = salesManItemsBalance!
          .map(
            (v) => v.toJson(),
          )
          .toList();
    }
    return data;
  }
}
