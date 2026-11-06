import '../../app/app_navigator.dart';

class SplashCoordinator {
  const SplashCoordinator();

  void goToHome() =>
      navigatorKey.currentState?.pushReplacementNamed(AppRoutes.home);

  void goToLogin() =>
      navigatorKey.currentState?.pushReplacementNamed(AppRoutes.login);
}
