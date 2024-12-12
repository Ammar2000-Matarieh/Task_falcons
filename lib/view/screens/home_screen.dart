import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_falcons/controllers/api_data.dart';
import 'package:task_falcons/view/widgets/custom_floating_button.dart';
import 'package:task_falcons/view/widgets/custom_home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerData = context.read<InventoryProvider>();
    if (providerData.items == null) {
      providerData.fetchAndMergeData();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        providerData: providerData,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: providerData.searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                  ),
                  hintText: "Search Products",
                  labelText: "Search Products",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const CustomHomeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
