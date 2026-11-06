import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'profile_coordinator.dart';
import 'profile_view.dart';
import 'profile_view_model.dart';
import 'server_profile.dart';

class ProfileFactory {
  const ProfileFactory._();

  static Widget make(AppDependencies dependencies) {
    final ServerProfile server = ServerProfileImpl(
      userRepository: dependencies.userRepository,
      authRepository: dependencies.authRepository,
      sessionStorage: dependencies.sessionStorage,
      themeController: dependencies.themeController,
    );
    const coordinator = ProfileCoordinator();
    final viewModel =
        ProfileViewModel(server: server, coordinator: coordinator);
    return ProfileView(viewModel: viewModel);
  }
}
