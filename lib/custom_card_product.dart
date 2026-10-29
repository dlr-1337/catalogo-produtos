import 'package:flutter/material.dart';

import 'product.dart';

// Card de um produto: ícone da categoria, nome, preço e botão Comprar
class CustomCardProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onBuy; // chamado ao tocar no card ou no botão Comprar

  const CustomCardProduct({
    super.key,
    required this.product,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final color = product.category.color;

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        // Faixa colorida à esquerda com a cor da categoria
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 6)),
        ),
        child: ListTile(
          onTap: onBuy,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: color.withAlpha(30),
            child: Icon(product.category.icon, color: color, size: 28),
          ),
          title: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.category.label),
              Text(
                product.formattedPrice,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          trailing: ElevatedButton.icon(
            onPressed: onBuy,
            icon: const Icon(Icons.add_shopping_cart, size: 18),
            label: const Text('Comprar'),
          ),
        ),
      ),
    );
  }
}
