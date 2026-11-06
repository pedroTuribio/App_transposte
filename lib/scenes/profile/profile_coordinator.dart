import '../../app/app_navigator.dart';

class ProfileCoordinator {
  const ProfileCoordinator();

  void goToTab(int index) => AppNavigator.goToTab(index);

  void goToLogin() => navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
}
