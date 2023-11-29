import "package:evaluation/main.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  // Liste des recettes
  final List<Recipe> recipes = [
    Recipe(
        "Hache",
        "Récolter le bois",
        [
          ProductionCost("Bois", 2),
          ProductionCost("Minerai de fer", 2),
        ],
        1),
    Recipe(
        "Pioche",
        "Récolter les minerais",
        [
          ProductionCost("Bois", 2),
          ProductionCost("Minerai de fer", 3),
        ],
        1),
    Recipe(
        "Lingot de fer",
        "Débloque d'autres recettes",
        [
          ProductionCost("Minerai de fer", 1),
        ],
        -1),
    Recipe(
        "Plaque de fer",
        "Débloque d'autres recettes",
        [
          ProductionCost("Minerai de fer", 3),
          ProductionCost("Minerai de fer", 3),
        ],
        -1),
    Recipe(
        "Lingot de cuivre",
        "Débloque d'autres recettes",
        [
          ProductionCost("Minerai de cuivre", 1),
        ],
        -1),
    Recipe(
        "Tige en métal",
        "Débloque d'autres recettes",
        [
          ProductionCost("Lingot de fer", 1),
        ],
        -1),
    Recipe(
        "Fil électrique",
        "Débloque d'autres recettes",
        [
          ProductionCost("Lingot de cuivre", 1),
        ],
        -1),
    Recipe(
        "Mineur",
        "Permet de transformer automatiquement d'extraire du minerai de fer ou cuivre",
        [
          ProductionCost("Plaque de fer", 10),
          ProductionCost("Fil électrique", 5),
        ],
        1),
    Recipe(
        "Fonderie",
        "Permet de transformer automatiquement du minerai de fer ou cuivre en lingot de fer ou cuivre",
        [
          ProductionCost("Fil électrique", 5),
          ProductionCost("Tige en métal", 8),
        ],
        1)
  ];

  @override
  Widget build(BuildContext context) {
    final counterNotifier = Provider.of<CounterNotifier>(context);
    final woodCounter = counterNotifier.woodCounter;
    final ironCounter = counterNotifier.ironCounter;
    final copperCounter = counterNotifier.copperCounter;
    final axeCount = counterNotifier.axeCount;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recettes"),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeWidget(recipes[index]);
        },
      ),
    );
  }
}

class ProductionCost {
  final String name;
  final int cost;

  ProductionCost(this.name, this.cost);
}

class Recipe {
  final String name;
  final String description;
  final List<ProductionCost> productionCosts;
  final int buildCountLimit;

  Recipe(
      this.name, this.description, this.productionCosts, this.buildCountLimit);
}

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;

  const RecipeWidget(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    final counterNotifier = Provider.of<CounterNotifier>(context);
    bool manufacturable(Recipe recipe) {
      List<ProductionCost> productionCosts = recipe.productionCosts;
      int buildCountLimit = recipe.buildCountLimit;

      switch (recipe.name) {
        case "Hache":
          if (counterNotifier.axeCount >= buildCountLimit) {
            return false;
          }
          break;
        case "Pioche":
          if (counterNotifier.pickaxeCount >= buildCountLimit) {
            return false;
          }
          break;
      }

      for (var productionCost in productionCosts) {
        switch (productionCost.name) {
          case "Bois":
            if (counterNotifier.woodCounter < productionCost.cost) {
              return false;
            }
            break;
          case "Minerai de fer":
            if (counterNotifier.ironCounter < productionCost.cost) {
              return false;
            }
            break;
          case "Minerai de cuivre":
            if (counterNotifier.copperCounter < productionCost.cost) {
              return false;
            }
            break;
        }
      }
      return true;
    }

    void incrementIngredientsCount(Recipe recipe) {
      List<ProductionCost> productionCosts = recipe.productionCosts;

      for (var productionCost in productionCosts) {
        switch (productionCost.name) {
          case "Bois":
            counterNotifier.incrementWoodCounter(-productionCost.cost);
            break;
          case "Minerai de fer":
            counterNotifier.incrementIronCounter(-productionCost.cost);
            break;
          case "Minerai de cuivre":
            counterNotifier.incrementCopperCounter(-productionCost.cost);
            break;
        }
      }

      switch (recipe.name) {
        case "Hache":
          counterNotifier.incrementAxeCount(1);
          break;
        case "Pioche":
          counterNotifier.incrementPickaxeCount(1);
          break;
      }
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(recipe.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description: ${recipe.description}"),
                Column(
                  children:
                      List.generate(recipe.productionCosts.length, (index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            const Text("Ingredients : "),
                            Text(recipe.productionCosts[index].name),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Coût : "),
                            Text(recipe.productionCosts[index].cost.toString()),
                          ],
                        )
                      ],
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    !manufacturable(recipe)
                        ? null
                        : incrementIngredientsCount(recipe);
                  },
                  child: !manufacturable(recipe)
                      ? const Icon(Icons.block)
                      : const Text("Produire"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
