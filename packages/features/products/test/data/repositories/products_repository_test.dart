import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:products/src/data/datasources/products_local_datasource.dart';
import 'package:products/src/data/datasources/products_remote_datasource.dart';
import 'package:products/src/data/mappers/product_mapper.dart';
import 'package:products/src/data/models/product_model.dart';
import 'package:products/src/data/repositories/products_repository_impl.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';

import 'products_repository_test.mocks.dart';

@GenerateMocks([ProductsRemoteDataSource, ProductsLocalDataSource])
void main() {
  late ProductsRepository repository;
  late ProductsRemoteDataSource remoteDataSource;
  late ProductsLocalDataSource localDataSource;
  late ProductMapper productMapper;

  setUp(() {
    remoteDataSource = MockProductsRemoteDataSource();
    localDataSource = MockProductsLocalDataSource();
    productMapper = ProductMapper();
    repository = ProductsRepositoryImpl(
      remoteDataSource,
      localDataSource,
      productMapper,
    );
  });

  final tempProducts = [
    ProductModel.fromJson({
      'id': '1',
      'title': 'title',
      'description': 'description',
      'price': 0.0,
    }),
  ];
  final resultProducts = [
    Product(id: '1', title: 'title', description: 'description', price: 0.0),
  ];

  group('fetch products from repository', () {
    test('test get products from local', () async {
      when(
        localDataSource.fetchProducts(),
      ).thenAnswer((_) async => tempProducts);

      final result = await repository.fetchProducts();

      expect(result.length, resultProducts.length);
      expect(result.runtimeType, resultProducts.runtimeType);

      verify(localDataSource.fetchProducts());
      verifyNoMoreInteractions(localDataSource);
    });

    test('test get products from remote', () async {
      when(localDataSource.fetchProducts()).thenAnswer((_) async => []);
      when(
        remoteDataSource.fetchProducts(),
      ).thenAnswer((_) async => tempProducts);

      final result = await repository.fetchProducts();

      expect(result.length, resultProducts.length);
      expect(result.runtimeType, resultProducts.runtimeType);

      verify(localDataSource.fetchProducts());
      verifyNoMoreInteractions(localDataSource);
      verify(remoteDataSource.fetchProducts());
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return error', () async {
      when(localDataSource.fetchProducts()).thenThrow(Exception());

      expect(() => repository.fetchProducts(), throwsA(isA<Exception>()));
    });
  });
}
