import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../scenes/design_system_showcase/design_system_showcase_factory.dart';
import '../scenes/home/home_factory.dart';
import '../scenes/login/login_factory.dart';
import '../scenes/profile/profile_factory.dart';
import '../scenes/splash/splash_factory.dart';
import 'app_dependencies.dart';

/// Chave global usada por todos os Coordinators para navegar.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const profile = '/profile';
  static const showcase = '/showcase';

  /// Ordem das abas da barra de navegação inferior.
  static const tabs = [home, profile, showcase];
}

/// Itens da barra inferior (Home, Perfil, Design System).
const List<YellowNavItem> appNavItems = [
  YellowNavItem(
      icon: Icons.credit_card_outlined,
      selectedIcon: Icons.credit_card_rounded,
      label: 'Cartão'),
  YellowNavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Perfil'),
  YellowNavItem(
      icon: Icons.palette_outlined,
      selectedIcon: Icons.palette_rounded,
      label: 'Design System'),
];

class AppNavigator {
  AppNavigator(this.dependencies);

  final AppDependencies dependencies;

  /// Troca de aba sem empilhar rotas.
  static void goToTab(int index) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.tabs[index],
      (route) => false,
    );
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _page(settings, LoginFactory.make(dependencies));
      case AppRoutes.home:
        return _tab(settings, HomeFactory.make(dependencies));
      case AppRoutes.profile:
        return _tab(settings, ProfileFactory.make(dependencies));
      case AppRoutes.showcase:
        return _tab(settings, DesignSystemShowcaseFactory.make(dependencies));
      case AppRoutes.splash:
      default:
        return _page(settings, SplashFactory.make(dependencies));
    }
  }

  Route<dynamic> _page(RouteSettings settings, Widget child) =>
      MaterialPageRoute<void>(settings: settings, builder: (_) => child);

  Route<dynamic> _tab(RouteSettings settings, Widget child) =>
      PageRouteBuilder<void>(
        settings: settings,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => child,
      );
}
