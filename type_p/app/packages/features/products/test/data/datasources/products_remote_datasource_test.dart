import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:products/src/data/datasources/impl/products_remote_datasource_impl.dart';
import 'package:products/src/data/datasources/products_remote_datasource.dart';
import 'package:products/src/data/models/product_model.dart';

import 'products_remote_datasource_test.mocks.dart';

@GenerateMocks([AppClient])
void main() {
  late AppClient storage;
  late ProductsRemoteDataSource dataSource;

  setUp(() {
    storage = MockAppClient();
    dataSource = ProductsRemoteDataSourceImpl(storage);
  });

  const productsKey = 'products';
  final resultProducts = [
    ProductModel.fromJson({
      'id': '1',
      'title': 'title',
      'description': 'description',
      'price': 0.0,
    }),
  ];

  group('fetch products from datasource', () {
    test('test get products', () async {
      when(storage.get(productsKey)).thenAnswer((_) async => resultProducts);

      final result = await dataSource.fetchProducts();

      expect(result.length, resultProducts.length);
      expect(result.runtimeType, resultProducts.runtimeType);

      verify(storage.get(productsKey));
      verifyNoMoreInteractions(storage);
    });

    test('should return api error', () async {
      when(storage.get(productsKey)).thenThrow(Exception());

      expect(() => dataSource.fetchProducts(), throwsA(isA<Exception>()));
    });
  });
}
