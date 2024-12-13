import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:task_falcons/controllers/api_data.dart';

List<SingleChildWidget> listProviders = [
  // Change UI AND LOGIC :
  ChangeNotifierProvider(
    create: (context) => ApiController(),
    lazy: true,
  ),
];
