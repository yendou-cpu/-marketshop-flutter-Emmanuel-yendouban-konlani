import 'package:boutique_app/Screens/login_Sreen.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// StatefulWidget — le code orphelin @override Widget build(...) est supprimé
class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> handleSignup() async {
    // Validation
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() => errorMessage = "Veuillez remplir tous les champs");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final success = await ApiService.signup(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte créé avec succès !")),
        );
        //  Retour à login après inscription réussie
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        setState(() => errorMessage = "Erreur lors de la création du compte");
      }
    } catch (e) {
      setState(() => errorMessage = "Erreur réseau. Vérifiez votre connexion.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titre
            const Text(
              'Inscription',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            // Champ nom d'utilisateur
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Nom d'utilisateur",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            // Champ email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 16),

            // Champ mot de passe
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 12),

            // Message d'erreur
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 12),

            // Bouton inscription
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleSignup,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("S'inscrire"),
              ),
            ),

            const SizedBox(height: 8),

            // Lien connexion
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Déjà un compte ?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Se connecter"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
