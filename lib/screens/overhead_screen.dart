import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/app_scaffold.dart';

class OverheadScreen extends StatefulWidget {
  const OverheadScreen({super.key});

  @override
  State<OverheadScreen> createState() => _OverheadScreenState();
}

class _OverheadScreenState extends State<OverheadScreen> {
  final box = Hive.box('overhead');
  final _name = TextEditingController();
  final _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Overhead Bulanan',
      child: Column(
        children: [
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _tf(_name, 'Nama biaya (Sewa, Gaji, Listrik, dll)'),
              _tf(_amount, 'Nominal / bulan', number: true),
              ElevatedButton.icon(
                onPressed: () {
                  if (_name.text.isEmpty || _amount.text.isEmpty) return;
                  box.put(_name.text, double.tryParse(_amount.text) ?? 0.0);
                  _name.clear(); _amount.clear();
                  setState((){});
                },
                icon: const Icon(Icons.save), label: const Text('Simpan / Update')),
            ],
          ),
          const Divider(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _list() {
    final keys = box.keys.toList()..sort();
    double total = 0;
    final tiles = keys.map((k) {
      final v = (box.get(k) as num).toDouble();
      total += v;
      return ListTile(
        title: Text('$k'),
        trailing: Text(v.toStringAsFixed(0)),
        onLongPress: () { box.delete(k); setState((){}); },
      );
    }).toList();
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (_, i) => tiles[i],
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: tiles.length,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Overhead / bulan', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(total.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tf(TextEditingController c, String label, {bool number = false}) {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
