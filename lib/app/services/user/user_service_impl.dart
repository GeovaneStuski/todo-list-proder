// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_list/app/repositories/users/user_repository.dart';
import 'package:flutter_todo_list/app/services/user/user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl({required UserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<User?> register(String email, String password) =>
      _userRepository.register(email, password);

  @override
  Future<User?> login(String email, String password) =>
      _userRepository.login(email, password);

  @override
  Future<void> forgorPassword(String email) =>
      _userRepository.forgotPassword(email);

  @override
  Future<User?> loginWithGoogle() => _userRepository.loginWithGoogle();

  @override
  Future<void> logout() => _userRepository.logout();
}
