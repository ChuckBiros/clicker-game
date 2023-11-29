import 'package:evaluation/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    final counterNotifier = Provider.of<CounterNotifier>(context);

    final List<InventoryItem> inventoryItems = [
      InventoryItem('Hache', counterNotifier.axeCount),
      InventoryItem('Pioche', counterNotifier.pickaxeCount)
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire'),
      ),
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          return InventoryItemWidget(inventoryItems[index]);
        },
      ),
    );
  }
}

class InventoryItem {
  final String name;
  final int quantity;

  InventoryItem(this.name, this.quantity);
}

class InventoryItemWidget extends StatelessWidget {
  final InventoryItem inventoryItem;

  const InventoryItemWidget(this.inventoryItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(inventoryItem.name),
        subtitle: Text('Quantity: ${inventoryItem.quantity}'),
      ),
    );
  }
}
