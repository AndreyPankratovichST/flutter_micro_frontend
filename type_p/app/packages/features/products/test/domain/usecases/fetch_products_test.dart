import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';
import 'package:products/src/domain/usecases/fetch_products_usecase.dart';
// import 'fetch_products_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  late FetchProductsUseCase useCase;
  late ProductsRepository repository;

  setUp(() {
    repository = MockProductsRepository();
    useCase = FetchProductsUseCase(repository);
  });

  final tempProducts = [Product()];

  group('fetch products', () {
    test('test get products items', () async {
      when(repository.fetchProducts()).thenAnswer((_) async => tempProducts);

      final result = await useCase(null);

      expect(result, tempProducts);
      verify(repository.fetchProducts());
      verifyNoMoreInteractions(repository);
    });

    test('should return server error', () async {
      when(repository.fetchProducts()).thenThrow(Exception());

      final result = await useCase(null);

      expect(result.runtimeType, equals(Exception().runtimeType));
    });
  });
}
