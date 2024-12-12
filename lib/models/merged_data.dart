import 'package:task_falcons/models/items/items_master.dart';

class MergedData {
  final ItemsMaster item;
  final String? quantity;

  MergedData({
    required this.item,
    this.quantity,
  });
}
