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

    // Salvar vazio mostra os erros e não sai da tela
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('Informe o nome do produto'), findsOneWidget);
    expect(find.text('Informe um preço válido'), findsOneWidget);

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

  test('Preço formatado em reais', () {
    const product = Product(
      name: 'X',
      price: 1234.5,
      category: ProductCategory.casa,
    );
    expect(product.formattedPrice, 'R\$ 1234,50');
  });
}
