import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/core/navigator/todo_list_navigator.dart';
import 'package:flutter_todo_list/app/services/user/user_service.dart';

class TodoListAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;
  User? _user;

  TodoListAuthProvider({
    required FirebaseAuth firebaseAuth,
    required UserService userService,
  }) : _firebaseAuth = firebaseAuth,
       _userService = userService;

  Future<void> logout() => _userService.logout();
  User? get user => _user;

  void loadListeners() {
    print("caiu aqui");
    _firebaseAuth.userChanges().listen((_) => notifyListeners());
    _firebaseAuth.idTokenChanges().listen((user) {
      if (user != null) {
        TodoListNavigator.to?.pushNamedAndRemoveUntil(
          "/home",
          (route) => false,
        );
        _user = user;
      } else {
        TodoListNavigator.to?.pushNamedAndRemoveUntil(
          "/login",
          (route) => false,
        );
      }
    });
  }
}
