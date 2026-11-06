import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'design_system_showcase_coordinator.dart';
import 'design_system_showcase_view.dart';
import 'design_system_showcase_view_model.dart';
import 'server_design_system_showcase.dart';

class DesignSystemShowcaseFactory {
  const DesignSystemShowcaseFactory._();

  static Widget make(AppDependencies dependencies) {
    const ServerDesignSystemShowcase server =
        ServerDesignSystemShowcaseImpl();
    const coordinator = DesignSystemShowcaseCoordinator();
    final viewModel = DesignSystemShowcaseViewModel(
      server: server,
      coordinator: coordinator,
    );
    return DesignSystemShowcaseView(viewModel: viewModel);
  }
}
