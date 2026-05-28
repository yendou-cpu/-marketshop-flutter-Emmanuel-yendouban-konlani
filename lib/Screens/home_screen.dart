import 'package:boutique_app/models/cart_database.dart';
import 'package:boutique_app/models/cart_item.dart';
import 'package:boutique_app/widgets/empty_state.dart';
import 'package:boutique_app/widgets/loading_widget.dart';
import 'package:boutique_app/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<String> categories = [];

  String? selectedCategory;

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  
  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        ApiService.fetchProducts(),
        ApiService.fetchCategories(),
      ]);

      setState(() {
        products = results[0] as List<Product>;

        categories = ['Tout', ...(results[1] as List<String>)];

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur de chargement";
        isLoading = false;
      });
    }
  }

  // Filtrer catégories
  Future<void> filterByCategory(String? category) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (category == null || category == 'Tout') {
        products = await ApiService.fetchProducts();
      } else {
        products = await ApiService.fetchByCategory(category);
      }

      setState(() {
        selectedCategory = category;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors du filtrage";
        isLoading = false;
      });
    }
  }

  // Ajouter au panier
  Future<void> addToCart(Product product) async {
    await CartDatabase.instance.addOrIncrement(
      CartItemModel(
        productId: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✓ ${product.title} ajouté au panier"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ma Boutique")),

      body: Column(
        children: [

          // FILTRES CATEGORIES
      
          if (categories.isNotEmpty)
            SizedBox(
              height: 50,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(horizontal: 8),

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  final isSelected = category == (selectedCategory ?? 'Tout');

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),

                    child: FilterChip(
                      label: Text(category),

                      selected: isSelected,

                      onSelected: (_) {
                        filterByCategory(category == 'Tout' ? null : category);
                      },
                    ),
                  );
                },
              ),
            ),

          
          Expanded(
            child: isLoading
                // LOADING
                ? const LoadingWidget(message: "Chargement des produits...")
                // ERREUR
                : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  )
                
                : products.isEmpty
                ? const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    message: "Aucun produit disponible",
                  )
                // GRILLE PRODUITS
                : GridView.builder(
                    padding: const EdgeInsets.all(12),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,

                          childAspectRatio: 0.65,

                          crossAxisSpacing: 12,

                          mainAxisSpacing: 12,
                        ),

                    itemCount: products.length,

                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,

                        onAddToCart: () {
                          addToCart(product);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
