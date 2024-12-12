import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_falcons/controllers/list_of_providers.dart';
import 'package:task_falcons/view/screens/home_screen.dart';

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: listProviders,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
