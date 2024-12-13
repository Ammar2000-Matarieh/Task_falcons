import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_falcons/controllers/api_data.dart';

class CustomHomeWidget extends StatelessWidget {
  const CustomHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiController>(
      builder: (
        context,
        apiController,
        _,
      ) {
        if (apiController.isLoading && apiController.filteredItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (apiController.hasError) {
          return Center(child: Text('Error: ${apiController.errorMessage}'));
        }

        if (apiController.filteredItems.isEmpty) {
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: apiController.filteredItems.length,
          itemBuilder: (context, index) {
            var data = apiController.filteredItems[index];
            int quantity = int.tryParse(data.quantity.toString()) ?? 0;
            Color quantityColor = apiController.getColorForItem(quantity);

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
                      const SizedBox(height: 6),
                      Text(
                        'Quantity: ${data.quantity.toString()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: quantityColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
