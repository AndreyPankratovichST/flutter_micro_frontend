import 'package:client/client.dart';
import 'package:di/di.dart';
import 'package:logger/logger.dart';
import 'package:products/di/module.dart';
import 'package:router/router.dart';
import 'package:storage/storage.dart';

Future<void> configurationApp() async {
  final di = DiCreateModule().create();

  /// Platform infrastructure
  await LoggerModule().build(di);
  await ClientModule().build(di);
  await StorageModule().build(di);
  await RouterModule().build(di);

  /// Features module
  await ProductsModule().build(di);
}
