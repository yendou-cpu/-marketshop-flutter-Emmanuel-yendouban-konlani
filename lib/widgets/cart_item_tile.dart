import 'package:boutique_app/models/cart_item.dart';
import 'package:flutter/material.dart';



class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemTile({
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
