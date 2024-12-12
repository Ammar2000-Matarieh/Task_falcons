import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_falcons/controllers/api_data.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    super.key,
    required this.providerData,
  });

  final ApiController providerData;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      onPressed: providerData.refreshData,
      child: const Icon(
        CupertinoIcons.refresh,
        color: Colors.white,
      ),
    );
  }
}
