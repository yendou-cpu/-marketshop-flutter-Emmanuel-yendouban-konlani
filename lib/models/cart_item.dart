// Modèle d'un article dans le panier
class CartItemModel {
  final int productId;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });


  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  // Créer depuis une ligne SQLite
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      title: map['title'],
      price: map['price'],
      image: map['image'],
      quantity: map['quantity'],
    );
  }
}
