// app_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'controllers/init_controller.dart';
import 'views/init_view.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [Bind.singleton((i) => InitController())];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const InitView()),
  ];
}
