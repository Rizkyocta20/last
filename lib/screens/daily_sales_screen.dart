import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/app_scaffold.dart';

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({super.key});

  @override
  State<DailySalesScreen> createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  final sales = Hive.box('sales');
  final products = Hive.box('products');
  DateTime selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Input Penjualan Harian',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: selected,
                  );
                  if (d != null) setState(() => selected = d);
                },
                icon: const Icon(Icons.date_range),
                label: Text('${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () { setState((){}); },
                icon: const Icon(Icons.refresh), label: const Text('Refresh')),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: _listForDay()),
        ],
      ),
    );
  }

  String get keyStr => '${selected.year}${selected.month.toString().padLeft(2, '0')}${selected.day.toString().padLeft(2, '0')}';

  Widget _listForDay() {
    final dayMap = (sales.get(keyStr) as Map?) ?? {};
    final productKeys = products.keys.toList()..sort();
    return ListView.separated(
      itemBuilder: (_, i) {
        final k = productKeys[i];
        final prod = products.get(k) as Map;
        final qty = (dayMap[k] ?? 0) as int;
        final controller = TextEditingController(text: qty.toString());
        return ListTile(
          title: Text('${prod['name']}'),
          trailing: SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()),
              onSubmitted: (v) {
                final n = int.tryParse(v) ?? 0;
                dayMap[k] = n;
                sales.put(keyStr, dayMap);
              },
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: productKeys.length,
    );
  }
}
