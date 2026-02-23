import 'package:flutter_todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:flutter_todo_list/app/exception/auth_exception.dart';
import 'package:flutter_todo_list/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;

  LoginController({required UserService userService})
    : _userService = userService;

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final user = await _userService.login(email, password);
      if (user != null) {
        success();
      } else {
        setError("Erro ao autenticar usuário");
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _userService.forgorPassword(email);
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final user = await _userService.loginWithGoogle();
      if (user != null) {
        success();
      } else {
        setError("Erro ao se autenticar com o Google!");
        await _userService.logout();
      }
    } on AuthException catch (e) {
      setError(e.message);
      await _userService.logout();
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _userService.logout();
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
