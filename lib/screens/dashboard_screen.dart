import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat datang di PopByte HPP & Daily Sales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: [
              _card(context, 'Ingredients', Icons.inventory_2, '/ingredients'),
              _card(context, 'Recipes / BOM', Icons.list, '/recipes'),
              _card(context, 'Overhead', Icons.account_balance_wallet, '/overhead'),
              _card(context, 'Daily Sales', Icons.calendar_today, '/daily'),
              _card(context, 'HPP Summary', Icons.summarize, '/hpp'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('1) Tambahkan bahan baku dahulu.\n2) Susun recipe/BOM tiap produk.\n3) Isi biaya overhead bulanan.\n4) Input penjualan harian.\n5) Cek HPP & harga jual rekomendasi.'),
        ],
      ),
    );
  }

  Widget _card(BuildContext ctx, String label, IconData icon, String route) {
    return InkWell(
      onTap: () => Navigator.of(ctx).pushNamed(route),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 160,
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
