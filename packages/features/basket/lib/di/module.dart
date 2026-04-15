import 'package:basket/src/data/datasources/basket_local_datasource.dart';
import 'package:basket/src/data/datasources/impl/basket_local_datasource_impl.dart';
import 'package:basket/src/data/mappers/product_mapper.dart';
import 'package:basket/src/data/repositories/basket_repository_impl.dart';
import 'package:basket/src/domain/repositories/basket_repository.dart';
import 'package:basket/src/domain/usecases/delete_from_basket_usecase.dart';
import 'package:basket/src/domain/usecases/fetch_basket_products_usecase.dart';
import 'package:basket/src/presentation/blocs/basket/basket_bloc.dart';
import 'package:basket/src/presentation/router/basket_router_module.dart';
import 'package:core/core.dart';

final class BasketModule implements DiModule {
  @override
  Future<void> build(Di di) async {
    di.get<AppRouter>().registerModule(BasketRouterModule());

    di.registerLazySingleton<BasketLocalDataSource>(
      () => BasketLocalDataSourceImpl(di.get()),
    );

    di.registerLazySingleton(() => ProductMapper());

    di.registerLazySingleton<BasketRepository>(
      () => BasketRepositoryImpl(di.get(), di.get()),
    );

    di.registerLazySingleton(() => FetchBasketProductsUseCase(di.get()));
    di.registerLazySingleton(() => DeleteFromBasketUseCase(di.get()));

    di.registerLazy(() => BasketBloc(di.get(), di.get()));
  }
}
