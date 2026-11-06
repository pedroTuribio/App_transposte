import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'login_coordinator.dart';
import 'login_view.dart';
import 'login_view_model.dart';
import 'server_login.dart';

class LoginFactory {
  const LoginFactory._();

  static Widget make(AppDependencies dependencies) {
    final ServerLogin server = ServerLoginImpl(
      authRepository: dependencies.authRepository,
      sessionStorage: dependencies.sessionStorage,
    );
    const coordinator = LoginCoordinator();
    final viewModel = LoginViewModel(server: server, coordinator: coordinator);
    return LoginView(viewModel: viewModel);
  }
}
