import '../../app/app_navigator.dart';

class LoginCoordinator {
  const LoginCoordinator();

  void goToHome() =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
}
