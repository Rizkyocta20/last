import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const AppScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('PopByte HPP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            _tile(context, Icons.dashboard, 'Dashboard', '/'),
            _tile(context, Icons.inventory_2, 'Ingredients', '/ingredients'),
            _tile(context, Icons.list, 'Recipes / BOM', '/recipes'),
            _tile(context, Icons.account_balance_wallet, 'Overhead', '/overhead'),
            _tile(context, Icons.calendar_today, 'Daily Sales', '/daily'),
            _tile(context, Icons.summarize, 'HPP Summary', '/hpp'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  ListTile _tile(BuildContext ctx, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(ctx);
        if (route == '/') {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => AppScaffold(title: 'Dashboard', child: Container())),
            (route) => false,
          );
        } else {
          Navigator.of(ctx).pushNamed(route);
        }
      },
    );
  }
}
