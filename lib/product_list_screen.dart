import 'package:flutter/material.dart';

import 'add_product_screen.dart';
import 'custom_card_product.dart';
import 'product.dart';

// Tela principal: catálogo com ListView.builder
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Estado da tela: a lista de produtos e a quantidade no carrinho
  final List<Product> products = Product.generateProducts();
  int cartCount = 0;

  // Abre a tela de cadastro e espera o Product devolvido pelo Navigator.pop
  Future<void> _addProduct() async {
    final newProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );

    // null = voltou sem salvar
    if (newProduct == null || !mounted) return;

    setState(() {
      products.add(newProduct); // entra no fim, sem apagar os outros
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newProduct.name} cadastrado no catálogo!')),
    );
  }

  void _buy(Product product) {
    setState(() {
      cartCount++;
    });
    // Esconde o aviso anterior para não acumular SnackBars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} adicionado ao carrinho!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            // Bolinha com o total de itens no carrinho
            child: Badge(
              label: Text('$cartCount'),
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_cart, semanticLabel: 'Carrinho'),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        // Espaço extra embaixo para o botão flutuante não cobrir o último card
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return CustomCardProduct(
            product: product,
            onBuy: () => _buy(product),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        icon: const Icon(Icons.add),
        label: const Text('Novo produto'),
      ),
    );
  }
}
