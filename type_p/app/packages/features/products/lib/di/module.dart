import 'package:core/core.dart';
import 'package:products/src/data/datasources/impl/products_local_datasource_impl.dart';
import 'package:products/src/data/datasources/impl/products_remote_datasource_impl.dart';
import 'package:products/src/data/datasources/products_local_datasource.dart';
import 'package:products/src/data/datasources/products_remote_datasource.dart';
import 'package:products/src/data/mappers/product_mapper.dart';
import 'package:products/src/data/repositories/products_repository_impl.dart';
import 'package:products/src/domain/repositories/products_repository.dart';
import 'package:products/src/domain/usecases/add_to_basket_usecase.dart';
import 'package:products/src/domain/usecases/fetch_products_usecase.dart';
import 'package:products/src/domain/usecases/get_products_basket_count_usecase.dart';
import 'package:products/src/presentation/blocs/products/products_bloc.dart';
import 'package:products/src/presentation/router/product_router_module.dart';

final class ProductsModule implements DiModule {
  @override
  Future<void> build(Di di) async {
    di.get<AppRouter>().registerModule(ProductRouterModule());

    di.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(di.get()),
    );
    di.registerLazySingleton<ProductsLocalDataSource>(
      () => ProductsLocalDataSourceImpl(di.get()),
    );

    di.registerLazySingleton<ProductMapper>(() => ProductMapper());

    di.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(di.get(), di.get(), di.get()),
    );

    di.registerLazySingleton<FetchProductsUseCase>(
      () => FetchProductsUseCase(di.get()),
    );
    di.registerLazySingleton<AddToBasketUseCase>(
      () => AddToBasketUseCase(di.get()),
    );
    di.registerLazySingleton<GetProductsBasketCountUseCase>(
      () => GetProductsBasketCountUseCase(di.get()),
    );

    di.registerLazy<ProductsBloc>(
      () => ProductsBloc(di.get(), di.get(), di.get()),
    );
  }
}
