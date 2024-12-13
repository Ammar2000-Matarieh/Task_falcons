import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_falcons/api/custom_api.dart';
import 'package:task_falcons/controllers/links_api.dart';
import 'package:task_falcons/models/items/items_model.dart';
import 'package:task_falcons/models/merged_data.dart';
import 'package:task_falcons/models/quantity/quantity_model.dart';

class ApiController extends ChangeNotifier {
  final ApiService apiService = ApiService();

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isAscending = true;

  List<MergedData> mergedItems = [];
  List<MergedData> filteredItems = [];

  Future<List<MergedData>>? _fetchedData;

  /// Fetch and Merge Data from APIs
  Future<List<MergedData>> fetchAndMergeData() async {
    if (_fetchedData != null) {
      return _fetchedData!;
    }

    try {
      final itemsResponse = await getDataItems(290, 4, 1);
      final quantityResponse = await getDataQuantity(290, 4, 9);

      if (itemsResponse == null || quantityResponse == null) {
        throw Exception("Failed to fetch valid data.");
      }

      final itemsModel = ItemsModel.fromJson(itemsResponse);
      final quantityModel = QuantityModel.fromJson(quantityResponse);

      if (itemsModel.itemsMaster == null ||
          quantityModel.salesManItemsBalance == null) {
        throw Exception("Failed to parse models.");
      }

      mergedItems.clear();

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

      filteredItems = List.from(
        mergedItems,
      );
      _fetchedData = Future.value(
        mergedItems,
      );
      notifyListeners();

      return mergedItems;
    } catch (e) {
      log(
        "Error fetching or merging data: $e",
      );
      rethrow;
    }
  }

  /// Fetch Items Data
  Future<Map<String, dynamic>?> getDataItems(
      int cono, int strno, int caseItems) async {
    try {
      var response = await apiService.getRequest(
        itemsApi,
        queryParams: {
          "cono": cono.toString(),
          "strno": strno.toString(),
          "caseItems": caseItems.toString(),
        },
      );
      return response;
    } catch (e) {
      log("Exception in getDataItems: $e");
      return null;
    }
  }

  /// Fetch Quantity Data
  Future<Map<String, dynamic>?> getDataQuantity(
      int cono, int strno, int caseItems) async {
    try {
      var response = await apiService.getRequest(
        quantityApi,
        queryParams: {
          "cono": cono.toString(),
          "strno": strno.toString(),
          "caseItems": caseItems.toString(),
        },
      );
      return response;
    } catch (e) {
      log("Exception in getDataQuantity: $e");
      return null;
    }
  }

  /// Refresh Data
  Future<void> refreshData() async {
    _fetchedData = null;
    await fetchAndMergeData();
    notifyListeners();
  }

  /// Search Items Functions :
  void searchItems(
    String query,
  ) {
    searchQuery = query.toLowerCase();
    filteredItems = mergedItems.where((
      item,
    ) {
      return item.item.nAME!.toLowerCase().contains(
                searchQuery,
              ) ||
          item.item.iTEMNO!.toLowerCase().contains(
                searchQuery,
              );
    }).toList();
    notifyListeners();
  }

  /// Sort Items Functions :
  void sortItems() {
    isAscending = !isAscending;
    filteredItems.sort(
      (a, b) => isAscending
          ? a.quantity!.compareTo(
              b.quantity!,
            )
          : b.quantity!.compareTo(
              a.quantity!,
            ),
    );
    notifyListeners();
  }
}
