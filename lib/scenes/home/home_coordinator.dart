import '../../app/app_navigator.dart';

class HomeCoordinator {
  const HomeCoordinator();

  void goToTab(int index) => AppNavigator.goToTab(index);

  void goToProfile() => AppNavigator.goToTab(1);

  void goToLogin() => navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
}
