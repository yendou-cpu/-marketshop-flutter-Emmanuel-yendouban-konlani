import 'package:boutique_app/models/cart_database.dart';
import 'package:boutique_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  // Recharge le panier depuis SQLite
  Future<void> loadCart() async {
    final data = await CartDatabase.instance.getAll();
    setState(() {
      items = data;
      isLoading = false;
    });
  }

  // Calcul du total
  double get total =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  // Modifier la quantité
  Future<void> updateQty(CartItemModel item, int newQty) async {
    await CartDatabase.instance.updateQuantity(item.productId, newQty);
    await loadCart();
  }

  // Supprimer un article
  Future<void> removeItem(CartItemModel item) async {
    await CartDatabase.instance.delete(item.productId);
    await loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          items.isEmpty
              ? "Mon Panier"
              : "Mon Panier (${items.fold(0, (s, i) => s + i.quantity)})",
        ),
        actions: [
          // Bouton vider panier
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: "Vider le panier",
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Vider le panier ?"),
                    content: const Text("Tous les articles seront supprimés."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Annuler"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Confirmer"),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await CartDatabase.instance.clearAll();
                  await loadCart();
                }
              },
            ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          //  Panier vide
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Votre panier est vide",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          // Liste des articles 
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemRow(
                        item: item,
                        onIncrease: () => updateQty(item, item.quantity + 1),
                        onDecrease: () => updateQty(item, item.quantity - 1),
                        onRemove: () => removeItem(item),
                      );
                    },
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total", style: TextStyle(fontSize: 16)),
                          Text(
                            "${total.toStringAsFixed(2)} €",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CheckoutScreen(items: items, total: total),
                              ),
                            ).then((_) => loadCart());
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Passer commande",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Ligne d'article ────────────────────────────────────────
class CartItemRow extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemRow({
    Key? key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 70),
              ),
            ),

            const SizedBox(width: 12),

            // Titre + prix + sous-total
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.price.toStringAsFixed(2)} € / unité",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    "Sous-total : ${(item.price * item.quantity).toStringAsFixed(2)} €",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Contrôles quantité  −  n  +
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    item.quantity == 1
                        ? Icons.delete
                        : Icons.remove_circle_outline,
                    color: item.quantity == 1 ? Colors.red : Colors.grey[700],
                    size: 20,
                  ),
                  onPressed: item.quantity == 1 ? onRemove : onDecrease,
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: Colors.green,
                  ),
                  onPressed: onIncrease,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
