import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/dashboard_screen.dart';
import 'screens/ingredients_screen.dart';
import 'screens/recipes_screen.dart';
import 'screens/overhead_screen.dart';
import 'screens/daily_sales_screen.dart';
import 'screens/hpp_summary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('ingredients');
  await Hive.openBox('recipes');     // product -> list of {ingredientCode, uom, qtyPerServe}
  await Hive.openBox('products');    // product -> {name, targetPrice?}
  await Hive.openBox('overhead');    // monthly costs map
  await Hive.openBox('sales');       // yyyymmdd -> {product: qty, ...}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopByte HPP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      routes: {
        '/ingredients': (_) => const IngredientsScreen(),
        '/recipes': (_) => const RecipesScreen(),
        '/overhead': (_) => const OverheadScreen(),
        '/daily': (_) => const DailySalesScreen(),
        '/hpp': (_) => const HPPSummaryScreen(),
      },
    );
  }
}
