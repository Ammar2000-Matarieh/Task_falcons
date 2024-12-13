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
            if (apiController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData &&
                apiController.filteredItems.isNotEmpty) {
              return const CustomListOfData();
            } else {
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
  const CustomListOfData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ApiController>();
    return RefreshIndicator(
      onRefresh: provider.refreshData,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: provider.filteredItems.length,
        itemBuilder: (context, index) {
          var data = provider.filteredItems[index];
          return Container(
            margin: const EdgeInsets.all(8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  12,
                ),
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
                      'Quantity: ${data.quantity}',
                      style: const TextStyle(fontSize: 16),
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
