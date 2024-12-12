import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_falcons/controllers/api_data.dart';
import 'package:task_falcons/models/merged_data.dart';

class CustomHomeWidget extends StatelessWidget {
  const CustomHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, child) {
        return FutureBuilder<List<MergedData>>(
          future: inventoryProvider.fetchAndMergeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var mergedData = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: mergedData.length,
                itemBuilder: (context, index) {
                  var data = mergedData[index];
                  return Container(
                    margin: const EdgeInsets.all(4),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(data.item.nAME ?? 'Unknown Item'),
                            const SizedBox(
                              height: 4,
                            ),
                            Text('Quantity: ${data.quantity}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
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
