import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_falcons/controllers/api_data.dart';
import 'package:task_falcons/view/widgets/custom_home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerData = context.read<ApiController>();

    // Fetch data when the screen loads if not already done
    if (providerData.filteredItems.isEmpty && !providerData.isLoading) {
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
        actions: [
          IconButton(
            icon: Icon(providerData.isAscending
                ? Icons.arrow_downward
                : Icons.arrow_upward),
            onPressed: () => providerData.sortItems(),
          ),
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await providerData.refreshData(); // Refresh data
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => providerData.searchItems(value),
                controller: providerData.searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.search),
                  hintText: "Search Products",
                  labelText: "Search Products",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              RefreshIndicator(
                onRefresh: providerData.refreshData,
                child: const CustomHomeWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
