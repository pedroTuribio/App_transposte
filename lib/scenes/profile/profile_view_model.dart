import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import 'profile_coordinator.dart';
import 'server_profile.dart';

enum ProfileStatus { loading, ready, error }

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required ServerProfile server,
    required ProfileCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator,
        _isDark = server.isDarkTheme;

  final ServerProfile _server;
  final ProfileCoordinator _coordinator;

  ProfileStatus _status = ProfileStatus.loading;
  String? _errorMessage;
  User? _user;
  bool _isDark;
  bool _isLoggingOut = false;

  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isDark => _isDark;
  bool get isLoggingOut => _isLoggingOut;

  String get name => _user?.name.isNotEmpty == true ? _user!.name : 'Estudante';
  String get email => _user?.email ?? '';
  String get maskedCpf => CpfUtils.mask(_user?.cpf ?? '');
  String get registration =>
      _user?.registration.isNotEmpty == true ? _user!.registration : '---';
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.first.isEmpty ? '' : parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Future<void> load() async {
    _status = ProfileStatus.loading;
    notifyListeners();
    final result = await _server.loadUser();
    if (result is Failure<User>) {
      if (result.error.isUnauthorized) {
        await _server.logout();
        _coordinator.goToLogin();
        return;
      }
      _status = ProfileStatus.error;
      _errorMessage = result.error.message;
    } else {
      _user = result.dataOrNull;
      _status = ProfileStatus.ready;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool dark) async {
    _isDark = dark;
    notifyListeners();
    await _server.setDarkTheme(dark);
  }

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    notifyListeners();
    await _server.logout();
    _isLoggingOut = false;
    notifyListeners();
    _coordinator.goToLogin();
  }

  void onTabSelected(int index) {
    if (index == 1) return;
    _coordinator.goToTab(index);
  }
}
