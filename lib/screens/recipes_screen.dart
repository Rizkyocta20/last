import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/app_scaffold.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final ingredients = Hive.box('ingredients');
  final recipes = Hive.box('recipes');
  final products = Hive.box('products');

  final _product = TextEditingController();
  final _targetPrice = TextEditingController();
  final _ingCode = TextEditingController();
  final _qtyPerServe = TextEditingController();
  final _uom = TextEditingController();

  List<Map<String, dynamic>> getLines(String p) {
    final list = (recipes.get(p) as List?)?.cast<Map<String, dynamic>>() ?? [];
    return List<Map<String, dynamic>>.from(list);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Recipes / BOM',
      child: Column(
        children: [
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _tf(_product, 'Nama Produk'),
              _tf(_targetPrice, 'Target Harga Jual (opsional)', number: true),
              ElevatedButton.icon(
                onPressed: () {
                  products.put(_product.text, {
                    'name': _product.text,
                    'target': double.tryParse(_targetPrice.text.isEmpty ? '0' : _targetPrice.text) ?? 0.0
                  });
                  setState((){});
                },
                icon: const Icon(Icons.save), label: const Text('Simpan Produk')),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _tf(_ingCode, 'Kode Bahan (harus ada di Ingredients)'),
              _tf(_qtyPerServe, 'Qty per Porsi', number: true),
              _tf(_uom, 'UoM (gram/ml/biji)'),
              ElevatedButton.icon(
                onPressed: () {
                  final p = _product.text;
                  if (p.isEmpty || _ingCode.text.isEmpty || _qtyPerServe.text.isEmpty) return;
                  final lines = getLines(p);
                  lines.add({
                    'code': _ingCode.text,
                    'qty': double.tryParse(_qtyPerServe.text) ?? 0.0,
                    'uom': _uom.text,
                  });
                  recipes.put(p, lines);
                  _ingCode.clear(); _qtyPerServe.clear(); _uom.clear();
                  setState((){});
                },
                icon: const Icon(Icons.add), label: const Text('Tambah Bahan ke Produk')),
            ],
          ),
          const Divider(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _list() {
    final keys = products.keys.toList()..sort();
    return ListView.separated(
      itemBuilder: (_, i) {
        final k = keys[i];
        final product = products.get(k) as Map;
        final lines = getLines(k);
        return ExpansionTile(
          title: Text('${product['name']} • Target: ${product['target'] ?? 0}'),
          children: [
            ...lines.map((e) => ListTile(
              title: Text('${e['code']} • Qty: ${e['qty']} ${e['uom']}'),
            )),
            if (lines.isEmpty) const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Belum ada bahan'),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: keys.length,
    );
  }

  Widget _tf(TextEditingController c, String label, {bool number = false}) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
