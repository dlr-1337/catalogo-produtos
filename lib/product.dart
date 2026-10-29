import 'package:flutter/material.dart';

// Categorias: cada uma tem nome, ícone e cor (o ícone do card vem daqui)
enum ProductCategory {
  eletronicos('Eletrônicos', Icons.devices, Colors.indigo),
  roupas('Roupas', Icons.checkroom, Colors.pink),
  alimentos('Alimentos', Icons.restaurant, Colors.deepOrange),
  livros('Livros', Icons.menu_book, Colors.brown),
  esportes('Esportes', Icons.sports_soccer, Colors.teal),
  casa('Casa', Icons.chair, Colors.blue);

  final String label;
  final IconData icon;
  final Color color;

  const ProductCategory(this.label, this.icon, this.color);
}

class Product {
  final String name;
  final double price;
  final ProductCategory category;

  const Product({
    required this.name,
    required this.price,
    required this.category,
  });

  // Preço no formato brasileiro: 1234.5 -> R$ 1234,50
  String get formattedPrice =>
      'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';

  // Produtos iniciais do catálogo.
  // A lista não é const para podermos adicionar produtos novos depois.
  static List<Product> generateProducts() {
    return [
      const Product(
        name: 'Notebook Gamer',
        price: 5500.00,
        category: ProductCategory.eletronicos,
      ),
      const Product(
        name: 'Fone Bluetooth',
        price: 249.90,
        category: ProductCategory.eletronicos,
      ),
      const Product(
        name: 'Camiseta Básica',
        price: 59.90,
        category: ProductCategory.roupas,
      ),
      const Product(
        name: 'Jaqueta Jeans',
        price: 189.90,
        category: ProductCategory.roupas,
      ),
      const Product(
        name: 'Café Especial 500g',
        price: 42.50,
        category: ProductCategory.alimentos,
      ),
      const Product(
        name: 'Chocolate Artesanal',
        price: 24.90,
        category: ProductCategory.alimentos,
      ),
      const Product(
        name: 'Dom Casmurro',
        price: 34.90,
        category: ProductCategory.livros,
      ),
      const Product(
        name: 'O Pequeno Príncipe',
        price: 29.90,
        category: ProductCategory.livros,
      ),
      const Product(
        name: 'Bola de Futebol',
        price: 119.90,
        category: ProductCategory.esportes,
      ),
      const Product(
        name: 'Luminária de Mesa',
        price: 89.90,
        category: ProductCategory.casa,
      ),
    ];
  }
}
