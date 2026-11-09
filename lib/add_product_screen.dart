import 'package:flutter/material.dart';

import 'product.dart';

// Tela "Cadastrar Produto": devolve o Product criado com Navigator.pop
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  ProductCategory?
  _selectedCategory; // começa vazio: o usuário tem que escolher

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Aceita vírgula ou ponto: "49,90" e "49.90" viram 49.9
  double? _parsePrice(String text) {
    return double.tryParse(text.trim().replaceAll(',', '.'));
  }

  // Regras do nome: a primeira que falhar vira a mensagem de erro
  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Informe o nome do produto';
    }
    if (name.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    if (name.length > 40) {
      return 'O nome deve ter no máximo 40 caracteres';
    }
    if (!RegExp(r'[a-zA-ZÀ-ÿ]').hasMatch(name)) {
      return 'O nome deve conter letras';
    }
    return null;
  }

  // Regras do preço
  String? _validatePrice(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Informe o preço';
    }
    // Só dígitos, com vírgula ou ponto opcional: 49 / 49,9 / 49.90
    if (!RegExp(r'^\d+([.,]\d+)?$').hasMatch(text)) {
      return 'Digite apenas números (ex: 49,90)';
    }
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(text)) {
      return 'Use no máximo 2 casas decimais';
    }
    final price = _parsePrice(text)!;
    if (price <= 0) {
      return 'O preço deve ser maior que zero';
    }
    if (price > 100000) {
      return 'O preço máximo é R\$ 100.000,00';
    }
    return null;
  }

  void _saveProduct() {
    // validate() roda os validators e mostra o erro embaixo de cada campo
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      name: _nameController.text.trim(),
      price: _parsePrice(_priceController.text)!,
      category: _selectedCategory!,
    );
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    // Sem categoria escolhida, a prévia mostra um ícone genérico
    final color = _selectedCategory?.color ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Prévia: o ícone muda conforme a categoria escolhida
              CircleAvatar(
                radius: 48,
                backgroundColor: color.withAlpha(30),
                child: Icon(
                  _selectedCategory?.icon ?? Icons.category,
                  color: color,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                  prefixIcon: Icon(Icons.label_outline),
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Preço (ex: 49,90)',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: _validatePrice,
              ),
              const SizedBox(height: 16),
              // Categoria escolhida com DropdownButton.
              // O FormField coloca o dropdown no Form para ele ser validado
              // junto com os outros campos e mostrar o erro do mesmo jeito.
              FormField<ProductCategory>(
                validator: (value) =>
                    value == null ? 'Selecione uma categoria' : null,
                builder: (field) => InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: const OutlineInputBorder(),
                    errorText: field.errorText,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProductCategory>(
                      value: _selectedCategory,
                      hint: const Text('Selecione'),
                      isExpanded: true,
                      isDense: true,
                      items: ProductCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Icon(category.icon, color: category.color),
                              const SizedBox(width: 12),
                              Text(category.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                        field.didChange(
                          value,
                        ); // avisa o FormField do novo valor
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProduct,
                  icon: const Icon(Icons.check),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
