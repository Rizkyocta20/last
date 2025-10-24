import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/app_scaffold.dart';

class HPPSummaryScreen extends StatelessWidget {
  const HPPSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients = Hive.box('ingredients');
    final recipes = Hive.box('recipes');
    final products = Hive.box('products');
    final overhead = Hive.box('overhead');
    final sales = Hive.box('sales');

    // Overhead total per month
    double monthlyOverhead = 0.0;
    for (var k in overhead.keys) {
      final v = (overhead.get(k) as num).toDouble();
      monthlyOverhead += v;
    }
    // Assume 30 days
    final dailyOverhead = monthlyOverhead / 30.0;

    List<_Row> rows = [];
    for (var k in products.keys) {
      final prod = products.get(k) as Map;
      final name = prod['name'] as String;
      final target = (prod['target'] as num?)?.toDouble() ?? 0.0;

      // Compute HPP per serve from recipe
      final lines = (recipes.get(k) as List?)?.cast<Map<String, dynamic>>() ?? [];
      double hpp = 0.0;
      for (var line in lines) {
        final code = line['code'];
        final qty = (line['qty'] as num?)?.toDouble() ?? 0.0;
        final ing = ingredients.get(code) as Map?;
        if (ing == null) continue;
        final pricePerUoI = (ing['price'] as num).toDouble();
        // We will assume UoI to UoM mapping is provided by the user conceptually; for now, treat UoI == UoM 1:1
        // If UoI is like "1 kg" and UoM is "gram", app expects user to convert price to per-gram before input.
        final cost = (pricePerUoI) * (qty); 
        hpp += cost;
      }

      final withError = hpp * 1.10;       // +10% margin error
      final withProfit = withError * 1.60; // +60% margin profit
      final withTax = withProfit * 1.12;   // +12% tax
      final recommendedPrice = withTax;

      // sales today (optional quick view)
      final now = DateTime.now();
      final keyStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final dayMap = (sales.get(keyStr) as Map?) ?? {};
      final sold = (dayMap[k] as int?) ?? 0;
      final revenueToday = sold * (target > 0 ? target : recommendedPrice);
      rows.add(_Row(name, hpp, withError, withProfit, withTax, target, recommendedPrice, sold, revenueToday));
    }

    final columns = const [
      DataColumn(label: Text('Produk')),
      DataColumn(label: Text('HPP')),
      DataColumn(label: Text('+10% Err')),
      DataColumn(label: Text('+60% Profit')),
      DataColumn(label: Text('+12% Tax')),
      DataColumn(label: Text('Target Jual')),
      DataColumn(label: Text('Rekomendasi Jual')),
      DataColumn(label: Text('Qty Hari ini')),
      DataColumn(label: Text('Omzet Hari ini')),
    ];

    return AppScaffold(
      title: 'HPP Summary',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: rows.map((r) => DataRow(cells: [
            DataCell(Text(r.name)),
            DataCell(Text(r.hpp.toStringAsFixed(0))),
            DataCell(Text(r.err.toStringAsFixed(0))),
            DataCell(Text(r.profit.toStringAsFixed(0))),
            DataCell(Text(r.tax.toStringAsFixed(0))),
            DataCell(Text(r.target > 0 ? r.target.toStringAsFixed(0) : '-')),
            DataCell(Text(r.recommended.toStringAsFixed(0))),
            DataCell(Text(r.qty.toString())),
            DataCell(Text(r.revenue.toStringAsFixed(0))),
          ])).toList(),
        ),
      ),
    );
  }
}

class _Row {
  final String name;
  final double hpp, err, profit, tax, target, recommended, revenue;
  final int qty;
  _Row(this.name, this.hpp, this.err, this.profit, this.tax, this.target, this.recommended, this.qty, this.revenue);
}
