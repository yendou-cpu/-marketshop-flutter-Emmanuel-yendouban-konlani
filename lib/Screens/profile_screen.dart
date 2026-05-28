import 'package:boutique_app/Screens/login_Sreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Champs utilisateur
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneController = TextEditingController();

  bool isEditing = false;
  bool darkMode = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // Charge le profil depuis SharedPreferences
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomController.text = prefs.getString('nom') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      telephoneController.text = prefs.getString('telephone') ?? '';
      darkMode = prefs.getBool('darkMode') ?? false;
      isLoading = false;
    });
  }

  // Sauvegarde le profil dans SharedPreferences
  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nom', nomController.text.trim());
    await prefs.setString('email', emailController.text.trim());
    await prefs.setString('telephone', telephoneController.text.trim());
    await prefs.setBool('darkMode', darkMode);

    setState(() => isEditing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✓ Profil mis à jour"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Vider toutes les données locales
  Future<void> viderDonnees() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.red, size: 40),
        title: const Text("Vider mes données ?"),
        content: const Text(
          "Cette action supprimera votre profil et votre panier. Elle est irréversible.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text("Confirmer",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Vider SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Vider le panier SQLite
      await CartDatabase.instance.clearAll();

      // Recharger le profil (vide maintenant)
      await loadProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Données supprimées")),
        );
      }
    }
  }

  // Initiales pour l'avatar
  String get initiales {
    final parts = nomController.text.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        actions: [
          // Bouton crayon / coche selon le mode
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            tooltip: isEditing ? "Sauvegarder" : "Modifier",
            onPressed: isEditing ? saveProfile : () => setState(() => isEditing = true),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // ── Avatar ──────────────────────────────────
                  CircleAvatar(
                    radius: 52,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      initiales,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Nom affiché sous l'avatar (mode lecture)
                  if (!isEditing) ...[
                    Text(
                      nomController.text.isEmpty
                          ? "Utilisateur"
                          : nomController.text,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      emailController.text,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ── Informations ────────────────────────────
                  _sectionTitle("Informations personnelles"),
                  const SizedBox(height: 12),

                  if (isEditing) ...[
                    
                    _field(
                      controller: nomController,
                      label: "Nom complet",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: telephoneController,
                      label: "Téléphone",
                      icon: Icons.phone,
                      type: TextInputType.phone,
                    ),
                  ] else ...[
                    
                    _infoRow(Icons.person, "Nom",
                        nomController.text.isEmpty
                            ? "Non renseigné"
                            : nomController.text),
                    _infoRow(Icons.email, "Email",
                        emailController.text.isEmpty
                            ? "Non renseigné"
                            : emailController.text),
                    _infoRow(Icons.phone, "Téléphone",
                        telephoneController.text.isEmpty
                            ? "Non renseigné"
                            : telephoneController.text),
                  ],

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),



                  //Deconnexion
                  _sectionTitle("Compte", color: Colors.orange),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Se déconnecter"),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  //Vider données
                  _sectionTitle("Zone de danger", color: Colors.red),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.red),
                      label: const Text("Vider mes données",
                          style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red)),
                      onPressed: viderDonnees,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  // ─ Helpers 

  Widget _sectionTitle(String title, {Color? color}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon,
              color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey[600])),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}