import 'package:expence_app/models/expence.dart';
import 'package:expence_app/pages/expences.dart';
import 'package:expence_app/server/categories_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(CategoriesAdapter());

  await Hive.openBox('expencesDatabase'); // 🔥 MUST be before runApp

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expences(),
    );
  }
}