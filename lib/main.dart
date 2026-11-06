import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'app/app_dependencies.dart';
import 'app/app_navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();
  runApp(MeuTransporteApp(dependencies: dependencies));
}

class MeuTransporteApp extends StatelessWidget {
  MeuTransporteApp({super.key, required this.dependencies})
      : _navigator = AppNavigator(dependencies);

  final AppDependencies dependencies;
  final AppNavigator _navigator;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: dependencies.themeController,
      builder: (context, mode, _) => MaterialApp(
        title: 'Meu Transporte',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: YellowTheme.light,
        darkTheme: YellowTheme.dark,
        themeMode: mode,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: _navigator.onGenerateRoute,
      ),
    );
  }
}
