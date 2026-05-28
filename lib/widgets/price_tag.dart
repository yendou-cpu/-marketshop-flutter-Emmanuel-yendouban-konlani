import 'package:flutter/material.dart';


class PriceTag extends StatelessWidget {
  final double price;
  final double fontSize;
  final FontWeight fontWeight;

  const PriceTag({
    Key? key,
    required this.price,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${price.toStringAsFixed(2)} €",
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
