import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_falcons/controllers/api_data.dart';
import 'package:task_falcons/models/merged_data.dart';

class CustomHomeWidget extends StatelessWidget {
  const CustomHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiController>(
      builder: (context, apiController, child) {
        return FutureBuilder<List<MergedData>>(
          future: apiController.fetchAndMergeData(),
          builder: (context, snapshot) {
            // Loading state
            if (apiController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Error handling
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Display data
            else if (snapshot.hasData &&
                apiController.filteredItems.isNotEmpty) {
              return const CustomListOfData();
            }
            // No data available
            else {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class CustomListOfData extends StatelessWidget {
  const CustomListOfData({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ApiController>(); // Access the provider

    return RefreshIndicator(
      onRefresh:
          provider.refreshData, // Refresh the data when the user pulls down
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: provider.filteredItems.length,
        itemBuilder: (context, index) {
          var data = provider.filteredItems[index];

          // Ensure quantity is an integer and handle potential conversion
          int quantity = int.tryParse(data.quantity.toString()) ?? 0;

          // Dynamically set the color based on quantity
          Color quantityColor = provider.getColorForItem(quantity);

          return Container(
            margin: const EdgeInsets.all(8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.item.nAME ?? 'Unknown Item',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Quantity: ${data.quantity.toString()}',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            quantityColor, // Apply color dynamically based on quantity
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
