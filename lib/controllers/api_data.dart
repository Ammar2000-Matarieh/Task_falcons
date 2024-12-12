import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_falcons/api/custom_api.dart';
import 'package:task_falcons/controllers/links_api.dart';
import 'package:task_falcons/models/items/items_model.dart';
import 'package:task_falcons/models/merged_data.dart';
import 'package:task_falcons/models/quantity/quantity_model.dart';

class InventoryProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  final searchController = TextEditingController();

  List<MergedData> mergedItems = [];

  Future<List<MergedData>>? items;

  Future<List<MergedData>> fetchAndMergeData() async {
    try {
      final itemsResponse = await getDataItems(
        290,
        4,
        1,
      );
      final quantityResponse = await getDataQuantity(
        290,
        4,
        9,
      );

      if (itemsResponse == null || quantityResponse == null) {
        log("Error: Failed to fetch valid data.");
        throw Exception("Failed to fetch valid data.");
      }

      log("Items Response: ${itemsResponse.toString()}");
      log("Quantity Response: ${quantityResponse.toString()}");

      final itemsModel = ItemsModel.fromJson(itemsResponse);
      final quantityModel = QuantityModel.fromJson(quantityResponse);

      if (itemsModel.itemsMaster == null ||
          quantityModel.salesManItemsBalance == null) {
        log("Error: Missing data in parsed models.");
        throw Exception("Failed to parse models.");
      }

      for (var item in itemsModel.itemsMaster!) {
        for (var qty in quantityModel.salesManItemsBalance!) {
          if (item.iTEMNO == qty.itemOCode) {
            mergedItems.add(
              MergedData(
                item: item,
                quantity: qty.qTY,
              ),
            );
          }
        }
      }

      return mergedItems;
    } catch (e) {
      log("Error fetching or merging data: $e");
      return [];
    }
  }

  /// Fetch Items Data
  Future<Map<String, dynamic>?> getDataItems(
      int cono, int strno, int caseItems) async {
    try {
      var response = await apiService.getRequest(itemsApi, queryParams: {
        "cono": cono.toString(),
        "strno": strno.toString(),
        "caseItems": caseItems.toString(),
      });

      // Check if response is not null
      if (response != null) {
        log("Items Response Body: ${response.toString()}");
        return response; // Assuming this is already the parsed JSON.
      } else {
        log("Error fetching items. Response is null.");
        return null;
      }
    } catch (e) {
      log("Exception in getDataItems: $e");
      return null;
    }
  }

  /// Fetch Quantity Data
  Future<Map<String, dynamic>?> getDataQuantity(
    int cono,
    int strno,
    int caseItems,
  ) async {
    try {
      var response = await apiService.getRequest(quantityApi, queryParams: {
        "cono": cono.toString(),
        "strno": strno.toString(),
        "caseItems": caseItems.toString(),
      });

      // Check if response is not null
      if (response != null) {
        log("Quantity Response Body: ${response.toString()}");
        return response; // Assuming this is already the parsed JSON.
      } else {
        log("Error fetching quantity. Response is null.");
        return null;
      }
    } catch (e) {
      log("Exception in getDataQuantity: $e");
      return null;
    }
  }

  // Refresh DataBase :
  void refreshData() {
    items = fetchAndMergeData();
    notifyListeners();
  }
}
