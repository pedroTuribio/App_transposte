import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'server_splash.dart';
import 'splash_coordinator.dart';
import 'splash_view.dart';
import 'splash_view_model.dart';

class SplashFactory {
  const SplashFactory._();

  static Widget make(AppDependencies dependencies) {
    final ServerSplash server = ServerSplashImpl(dependencies.sessionStorage);
    const coordinator = SplashCoordinator();
    final viewModel = SplashViewModel(server: server, coordinator: coordinator);
    return SplashView(viewModel: viewModel);
  }
}
