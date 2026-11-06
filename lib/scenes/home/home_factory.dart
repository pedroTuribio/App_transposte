import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'home_coordinator.dart';
import 'home_view.dart';
import 'home_view_model.dart';
import 'server_home.dart';

class HomeFactory {
  const HomeFactory._();

  static Widget make(AppDependencies dependencies) {
    final ServerHome server = ServerHomeImpl(
      balanceRepository: dependencies.balanceRepository,
      sessionStorage: dependencies.sessionStorage,
    );
    const coordinator = HomeCoordinator();
    final viewModel = HomeViewModel(server: server, coordinator: coordinator);
    return HomeView(viewModel: viewModel);
  }
}
