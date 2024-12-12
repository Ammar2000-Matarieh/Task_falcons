import 'package:task_falcons/models/items/items_master.dart';

class ItemsModel {
  List<ItemsMaster>? itemsMaster;

  ItemsModel({
    this.itemsMaster,
  });

  ItemsModel.fromJson(Map<String, dynamic> json) {
    if (json['Items_Master'] != null) {
      itemsMaster = <ItemsMaster>[];
      json['Items_Master'].forEach(
        (v) {
          itemsMaster!.add(
            ItemsMaster.fromJson(v),
          );
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (itemsMaster != null) {
      data['Items_Master'] = itemsMaster!
          .map(
            (v) => v.toJson(),
          )
          .toList();
    }
    return data;
  }
}
