import 'package:boutique_app/models/cart_database.dart';
import 'package:boutique_app/models/cart_item.dart';
import 'package:flutter/material.dart';


class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> items;
  final double total;

  const CheckoutScreen({Key? key, required this.items, required this.total})
    : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final phoneController = TextEditingController();
  final adresseController = TextEditingController();
  final villeController = TextEditingController();

  bool isLoading = false;

  Future<void> confirmerCommande() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // Simule une sauvegarde (à remplacer par ta DB commandes)
    await Future.delayed(const Duration(seconds: 1));

    // Vide le panier après commande
    await CartDatabase.instance.clearAll();

    setState(() => isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✓ Commande confirmée !"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // retour au panier (maintenant vide)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passer commande")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Formulaire livraison ───────────────────────
              const Text(
                "Informations de livraison",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: "Nom complet *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Téléphone *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Champ obligatoire";
                  if (!RegExp(r'^\d+$').hasMatch(v))
                    return "Numérique uniquement";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: adresseController,
                decoration: const InputDecoration(
                  labelText: "Adresse *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: villeController,
                decoration: const InputDecoration(
                  labelText: "Ville *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              //Récapitulatif 
              const Text(
                "Récapitulatif",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ...widget.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${item.title.length > 30 ? item.title.substring(0, 30) + '…' : item.title}  ×${item.quantity}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        "${(item.price * item.quantity).toStringAsFixed(2)} €",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.total.toStringAsFixed(2)} €",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Bouton confirmer ───────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : confirmerCommande,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Confirmer la commande",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
