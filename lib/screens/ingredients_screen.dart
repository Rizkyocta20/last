import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/app_scaffold.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _uoi = TextEditingController(); // Unit of Issue (e.g., 1 pack, 1 kg)
  final _uom = TextEditingController(); // Unit of Measure (e.g., gram, ml)
  final _price = TextEditingController(); // price per UOI
  final box = Hive.box('ingredients');

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Ingredients',
      child: Column(
        children: [
          _form(),
          const Divider(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _form() {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: [
        _tf(_code, 'Kode'),
        _tf(_name, 'Nama'),
        _tf(_brand, 'Brand (opsional)'),
        _tf(_uoi, 'UoI (contoh: 1 kg, 1 pack)'),
        _tf(_uom, 'UoM (contoh: gram, ml)'),
        _tf(_price, 'Harga per UoI (angka)', number: true),
        ElevatedButton.icon(
          onPressed: () {
            if (_code.text.isEmpty || _name.text.isEmpty || _uoi.text.isEmpty || _uom.text.isEmpty || _price.text.isEmpty) return;
            box.put(_code.text, {
              'name': _name.text,
              'brand': _brand.text,
              'uoi': _uoi.text,
              'uom': _uom.text,
              'price': double.tryParse(_price.text) ?? 0.0,
            });
            _code.clear(); _name.clear(); _brand.clear(); _uoi.clear(); _uom.clear(); _price.clear();
            setState((){});
          },
          icon: const Icon(Icons.save), label: const Text('Simpan / Update')),
      ],
    );
  }

  Widget _list() {
    final keys = box.keys.toList()..sort();
    return ListView.separated(
      itemBuilder: (_, i) {
        final k = keys[i];
        final v = box.get(k) as Map;
        return ListTile(
          title: Text('$k • ${v['name']}'),
          subtitle: Text('UoI: ${v['uoi']}, UoM: ${v['uom']}, Harga/UoI: ${v['price']}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () { box.delete(k); setState((){}); },
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: keys.length,
    );
  }

  Widget _tf(TextEditingController c, String label, {bool number = false}) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
