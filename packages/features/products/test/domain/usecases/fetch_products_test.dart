import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';
import 'package:products/src/domain/usecases/fetch_products_usecase.dart';
import 'fetch_products_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  late FetchProductsUseCase useCase;
  late ProductsRepository repository;

  setUp(() {
    repository = MockProductsRepository();
    useCase = FetchProductsUseCase(repository);
  });

  final tempProducts = [
    Product(id: '1', title: 'title', description: 'description', price: 0.0),
  ];

  group('fetch products from usecase', () {
    test('test get products', () async {
      when(repository.fetchProducts()).thenAnswer((_) async => tempProducts);

      final result = await useCase(null);

      expect(result, tempProducts);

      verify(repository.fetchProducts());
      verifyNoMoreInteractions(repository);
    });

    test('should return error', () async {
      when(repository.fetchProducts()).thenThrow(Exception());

      expect(() => useCase(null), throwsA(isA<Exception>()));
    });
  });
}
