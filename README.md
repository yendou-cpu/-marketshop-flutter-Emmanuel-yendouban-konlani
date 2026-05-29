

## Étudiant
- KONLANI Yendouban Emmanuel
* **Lien vers la version Kotlin :**  **Lien vers la version Kotlin :** [https://github.com/yendou-cpu/-marketshop-kotlin-yendouban-emmanuel-konlani](#)

---

## Description
**Ma boutique** est une application mobile de mini e-commerce développée en **Flutter** avec **Dart**.

Elle permet à l'utilisateur de parcourir un catalogue de produits, d'ajouter des articles à un panier, de passer commande et de consulter son profil. Les données produits proviennent de l'API publique **FakeStoreAPI**, le panier est persisté localement avec **sqflite**, tandis que la gestion du profil utilise **shared_preferences**.

---

##  Fonctionnalités implémentées

### Authentification
* [x] Écran de connexion (login avec token JWT)
* [x] Écran d'inscription (signup)
* [x] Navigation vers l'app après authentification
* [x] Déconnexion depuis le profil

### Écran Catalogue
* [x] Affichage des produits en grille 2 colonnes (`GridView`)
* [x] Image, titre, prix, catégorie sur chaque carte
* [x] Filtre par catégorie (`FilterChip` horizontal)


### Écran Détail produit
* [ ] Écran détail séparé (accès direct depuis le catalogue)

### Écran Panier


### Écran Commande
* [x] Formulaire : nom, téléphone, adresse, ville
* [x] Validation des champs (téléphone numérique)
* [x] Récapitulatif du panier en lecture seule
* [x] Vidage du panier après confirmation
* [ ] Sauvegarde dans une base commandes

### Écran Historique
* [ ] Non implémenté

### Écran Profil
* [x] Chargement des infos depuis l'API (`GET /users/1`)
* [x] Modification locale (`shared_preferences`)
* [x] Rechargement depuis l'API (bouton refresh)
* [x] Switch mode sombre
* [x] Bouton "Vider mes données" avec confirmation
* [x] Déconnexion

### Navigation
* [x] Bottom Navigation Bar (Catalogue, Panier, Historique, Profil)
* [x] Navigation vers `CheckoutScreen` depuis le panier

---

##  Bibliothèques utilisées

| Bibliothèque | Version | Usage |
| :--- | :--- | :--- |
| **`http`** | `^1.0.0` | Appels API REST |
| **`sqflite`** | `^2.3.0` | Persistance locale (panier) |
| **`path`** | `^1.8.3` | Chemins fichiers SQLite |
| **`shared_preferences`** | `^2.2.0` | Persistance profil utilisateur |
| **`flutter` (SDK)** | `3.x` | Framework UI |

---

##  Captures d'écran


| Login | Catalogue | Commande |
| :---: | :---: | :---: |
| ![Login](https://github.com/yendou-cpu/-marketshop-flutter-Emmanuel-yendouban-konlani/blob/main/lib/screenshots/login.jpeg) | ![Catalogue](https://github.com/yendou-cpu/-marketshop-flutter-Emmanuel-yendouban-konlani/blob/main/lib/screenshots/catalogue.jpeg) | ![Commande](https://github.com/yendou-cpu/-marketshop-flutter-Emmanuel-yendouban-konlani/blob/main/lib/screenshots/commande.jpeg) |

---

##  Difficultés rencontrées

1. **Configuration du NDK Android :** La principale difficulté a été la configuration du NDK Android — le dossier `28.2.13676358` était corrompu, ce qui bloquait le build Flutter avec l'erreur `[CXX1101] NDK did not have a source.properties file`. La solution a été de supprimer manuellement ce dossier et de laisser Gradle le re-télécharger automatiquement.
2. **Gestion des statuts HTTP :** Une autre difficulté a été la gestion du statut HTTP 201 retourné par FakeStoreAPI lors du login : notre code initial vérifiait uniquement `statusCode == 200`, ce qui marquait systématiquement le login comme échoué malgré un token valide présent dans la réponse.
3. **Synchronisation d'états :** Enfin, la synchronisation du panier entre le `HomeScreen` et le `CartScreen` via `sqflite` a nécessité d'appeler explicitement `loadCart()` à chaque retour sur l'écran panier en utilisant la structure `.then((_) => loadCart())`.

---

## Améliorations possibles

Avec plus de temps, nous aurions apporté les optimisations suivantes :
* **Expérience Utilisateur :** Implémentation d'un écran de détail produit complet avec sélecteur de quantité avant l'ajout au panier, ainsi qu'une barre de recherche textuelle dans le catalogue.
* **Nouvelles Fonctionnalités :** Gestion complète de l'historique des commandes persistant dans `sqflite`.
* **Architecture & Navigation :** Centralisation du mode sombre dynamique via un `ThemeNotifier` avec *Provider*, et fluidification de la navigation à l'aide d'animations de transition gérées par *go_router*.
* **Sécurité & Mode Hors-ligne :** Renforcement de la sécurité en stockant le token JWT dans *flutter_secure_storage* plutôt qu'en mémoire volatile, et ajout d'une mise en cache des produits pour permettre une navigation fluide même sans connexion Internet.
