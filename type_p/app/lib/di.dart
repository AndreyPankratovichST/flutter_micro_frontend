import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:core/di/core_module.dart';
import 'package:shared/di/shared_module.dart';
import 'package:config/di/config_module.dart';
import 'package:start/di/start_module.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() {
  $initGetIt(getIt);
  configureCoreDependencies(getIt);
  configureConfigDependencies(getIt);
  configureSharedDependencies(getIt);
  configureStartDependencies(getIt);
}