import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catalogo_produtos/main.dart';
import 'package:catalogo_produtos/product.dart';

void main() {
  testWidgets('Comprar e tocar no produto mostram SnackBar do carrinho', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Notebook Gamer'), findsOneWidget);
    expect(find.text('R\$ 5500,00'), findsOneWidget);

    // Botão Comprar do primeiro card
    await tester.tap(find.text('Comprar').first);
    await tester.pump();
    expect(find.text('Notebook Gamer adicionado ao carrinho!'), findsOneWidget);
    expect(find.text('1'), findsOneWidget); // contador do carrinho

    // Toque no próprio produto (no nome)
    await tester.tap(find.text('Fone Bluetooth'));
    await tester.pump();
    expect(find.text('Fone Bluetooth adicionado ao carrinho!'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Cadastrar produto adiciona no fim sem apagar os outros', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // FAB abre a tela Cadastrar Produto
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar Produto'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome do produto'),
      'Bola de Vôlei',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Preço (ex: 49,90)'),
      '79,90',
    );

    // Escolhe a categoria no DropdownButton
    await tester.tap(find.byType(DropdownButton<ProductCategory>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Esportes').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    // De volta ao catálogo, o primeiro produto continua lá
    expect(find.text('Catálogo de Produtos'), findsOneWidget);
    expect(find.text('Notebook Gamer'), findsOneWidget);

    // O produto novo aparece no final da lista
    await tester.scrollUntilVisible(find.text('Bola de Vôlei'), 300);
    expect(find.text('Bola de Vôlei'), findsOneWidget);
    expect(find.text('R\$ 79,90'), findsOneWidget);
  });

  testWidgets('Form mostra o erro de cada regra e não sai da tela', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Preenche nome e preço, toca em Salvar e confere as mensagens
    Future<void> salvar(String nome, String preco, List<String> erros) async {
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome do produto'),
        nome,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Preço (ex: 49,90)'),
        preco,
      );
      await tester.tap(find.text('Salvar'));
      await tester.pump();
      for (final erro in erros) {
        expect(find.text(erro), findsOneWidget);
      }
    }

    await salvar('', '', [
      'Informe o nome do produto',
      'Informe o preço',
      'Selecione uma categoria',
    ]);
    await salvar('TV', 'abc', [
      'O nome deve ter pelo menos 3 caracteres',
      'Digite apenas números (ex: 49,90)',
    ]);
    await salvar('A' * 41, '10,999', [
      'O nome deve ter no máximo 40 caracteres',
      'Use no máximo 2 casas decimais',
    ]);
    await salvar('12345', '0', [
      'O nome deve conter letras',
      'O preço deve ser maior que zero',
    ]);
    await salvar('Geladeira', '150000', ['O preço máximo é R\$ 100.000,00']);

    // Nenhum cadastro passou: continua na tela de cadastro
    expect(find.text('Cadastrar Produto'), findsOneWidget);
  });

  test('Preço formatado em reais', () {
    const product = Product(
      name: 'X',
      price: 1234.5,
      category: ProductCategory.casa,
    );
    expect(product.formattedPrice, 'R\$ 1234,50');
  });
}
