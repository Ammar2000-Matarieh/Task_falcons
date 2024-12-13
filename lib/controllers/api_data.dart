import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_falcons/api/custom_api.dart';
import 'package:task_falcons/controllers/links_api.dart';
import 'package:task_falcons/models/items/items_model.dart';
import 'package:task_falcons/models/merged_data.dart';
import 'package:task_falcons/models/quantity/quantity_model.dart';

class ApiController extends ChangeNotifier {
  final apiService = ApiService();

  final searchController = TextEditingController();
  String searchQuery = '';
  bool isAscending = true;
  bool isLoading = false; // Track loading state

  List<MergedData> mergedItems = [];
  List<MergedData> filteredItems = [];

  Future<List<MergedData>>? _fetchedData;

  /// Fetch and Merge Data from APIs
  Future<List<MergedData>> fetchAndMergeData() async {
    if (_fetchedData != null) {
      return _fetchedData!;
    }

    isLoading = true; // Set loading to true
    // notifyListeners();

    try {
      // Fetch data concurrently using Future.wait
      final results = await Future.wait([
        getDataItems(
          290,
          4,
          1,
        ),
        getDataQuantity(
          290,
          4,
          9,
        ),
      ]);

      // Extract responses
      final itemsResponse = results[0];
      final quantityResponse = results[1];

      if (itemsResponse == null || quantityResponse == null) {
        throw Exception("Failed to fetch valid data.");
      }

      // Parse responses into models
      final itemsModel = ItemsModel.fromJson(itemsResponse);
      final quantityModel = QuantityModel.fromJson(quantityResponse);

      if (itemsModel.itemsMaster == null ||
          quantityModel.salesManItemsBalance == null) {
        throw Exception("Failed to parse models.");
      }

      // Merge data
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

      // Update filtered items
      filteredItems = List.from(
        mergedItems,
      );
      _fetchedData = Future.value(
        mergedItems,
      );

      isLoading = false; // Set loading to false once data is fetched
      notifyListeners();

      return mergedItems;
    } catch (e) {
      isLoading = false;
      log("Error fetching or merging data: $e");
      notifyListeners();
      rethrow;
    }
  }

  /// Other methods (getDataItems, getDataQuantity, etc.)

// class ApiController extends ChangeNotifier {
//   final apiService = ApiService();

//   final searchController = TextEditingController();
//   String searchQuery = '';
//   bool isAscending = true;

//   List<MergedData> mergedItems = [];
//   List<MergedData> filteredItems = [];

//   Future<List<MergedData>>? _fetchedData;

//   /// Fetch and Merge Data from APIs
//   Future<List<MergedData>> fetchAndMergeData() async {
//     if (_fetchedData != null) {
//       return _fetchedData!;
//     }

//     try {
//       // Fetch data concurrently using Future.wait
//       final results = await Future.wait([
//         getDataItems(
//           290,
//           4,
//           1,
//         ),
//         getDataQuantity(
//           290,
//           4,
//           9,
//         ),
//       ]);

//       // Extract responses
//       final itemsResponse = results[0];
//       final quantityResponse = results[1];

//       if (itemsResponse == null || quantityResponse == null) {
//         throw Exception("Failed to fetch valid data.");
//       }

//       // Parse responses into models
//       final itemsModel = ItemsModel.fromJson(itemsResponse);
//       final quantityModel = QuantityModel.fromJson(quantityResponse);

//       if (itemsModel.itemsMaster == null ||
//           quantityModel.salesManItemsBalance == null) {
//         throw Exception("Failed to parse models.");
//       }

//       // Merge data
//       mergedItems.clear();
//       for (var item in itemsModel.itemsMaster!) {
//         for (var qty in quantityModel.salesManItemsBalance!) {
//           if (item.iTEMNO == qty.itemOCode) {
//             mergedItems.add(
//               MergedData(
//                 item: item,
//                 quantity: qty.qTY,
//               ),
//             );
//           }
//         }
//       }

//       // Update filtered items
//       filteredItems = List.from(mergedItems);
//       _fetchedData = Future.value(mergedItems);
//       notifyListeners();

//       return mergedItems;
//     } catch (e) {
//       log("Error fetching or merging data: $e");
//       rethrow;
//     }
//   }

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

  /// Search Items Function
  void searchItems(String query) {
    searchQuery = query.toLowerCase();
    filteredItems = mergedItems.where((item) {
      return item.item.nAME!.toLowerCase().contains(searchQuery) ||
          item.item.iTEMNO!.toLowerCase().contains(searchQuery);
    }).toList();
    notifyListeners();
  }

  /// Sort Items Function
  void sortItems() {
    isAscending = !isAscending;
    filteredItems.sort(
      (a, b) => isAscending
          ? a.quantity!.compareTo(b.quantity!)
          : b.quantity!.compareTo(a.quantity!),
    );
    notifyListeners();
  }
}
