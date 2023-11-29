import 'package:evaluation/pages/inventory-page.dart';
import 'package:evaluation/pages/recipes-page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class CounterNotifier extends ChangeNotifier {
  int _woodCounter = 0;
  int _ironCounter = 0;
  int _copperCounter = 0;

  int _axeCount = 0;
  int _pickaxeCount = 0;

  int get woodCounter => _woodCounter;
  int get ironCounter => _ironCounter;
  int get copperCounter => _copperCounter;

  int get axeCount => _axeCount;
  int get pickaxeCount => _pickaxeCount;

  void incrementWoodCounter(int value) {
    _woodCounter += value;
    notifyListeners();
  }

  void incrementIronCounter(int value) {
    _ironCounter += value;
    notifyListeners();
  }

  void incrementCopperCounter(int value) {
    _copperCounter += value;
    notifyListeners();
  }

  void incrementAxeCount(int value) {
    _axeCount += value;
    notifyListeners();
  }

  void incrementPickaxeCount(int value) {
    _pickaxeCount += value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterNotifier(),
      child: const MaterialApp(
        title: 'Clicker Game',
        home: ResourcesPage(),
      ),
    );
  }
}

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    final counterNotifier = Provider.of<CounterNotifier>(context);
    final woodCounter = counterNotifier.woodCounter;
    final ironCounter = counterNotifier.ironCounter;
    final copperCounter = counterNotifier.copperCounter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InventoryPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          ResourceWidget(
              'Bois',
              woodCounter,
              const Color(0xFF967969),
              () => counterNotifier
                  .incrementWoodCounter(counterNotifier.axeCount > 0 ? 3 : 1)),
          ResourceWidget(
              'Minerais de fer',
              ironCounter,
              const Color(0xFFCED4DA),
              () => counterNotifier.incrementIronCounter(
                  counterNotifier.pickaxeCount > 0 ? 5 : 1)),
          ResourceWidget(
              'Minerais de cuivre',
              copperCounter,
              const Color(0xFFD9480F),
              () => counterNotifier.incrementCopperCounter(
                  counterNotifier.pickaxeCount > 0 ? 5 : 1))
        ],
      ),
    );
  }
}

class ResourceWidget extends StatelessWidget {
  final String resourceName;
  final int count;
  final Color color;
  final Function() onMine;

  const ResourceWidget(this.resourceName, this.count, this.color, this.onMine,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onMine,
      child: Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(resourceName),
            Text('Quantité: $count'),
            ElevatedButton(
              onPressed: onMine,
              child: const Text('Récolter'),
            ),
          ],
        ),
      ),
    );
  }
}
