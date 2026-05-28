import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // LOGIN 
  static Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login status: ${response.statusCode}');
      print('Login body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'] as String?;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // PRODUITS 
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Erreur produits : ${response.statusCode}');
  }

  static Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception('Produit introuvable');
  }

  static Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/products/categories'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<String>();
    }
    throw Exception('Erreur catégories');
  }

  static Future<List<Product>> fetchByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Erreur catégorie');
  }

  //SIGNUP 
  static Future<bool> signup(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
