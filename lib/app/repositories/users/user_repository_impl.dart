// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_list/app/exception/auth_exception.dart';

import 'package:flutter_todo_list/app/repositories/users/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user != null) {
        await user.user!.sendEmailVerification();
      }

      return user.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-in-use') {
        throw AuthException(
          message: "E-mail já utilizado, por favor escolha outro e-mail!",
        );
      }

      throw AuthException(message: "Erro ao cadastrar usuário");
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(user.user);

      return user.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);

      throw AuthException(message: "Erro ao autenticar usuário");
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);

      throw AuthException(message: "Erro ao autenticar usuário");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e, s) {
      print(e);
      print(s);

      throw AuthException(message: "Erro ao recuperar senha do usuário");
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);

      throw AuthException(message: "Erro ao recuperar senha do usuário");
    }
  }

  @override
  Future<User?> loginWithGoogle() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      print(user?.uid);
      print(user?.email);
      print(user?.emailVerified);
      print(user?.providerData.map((e) => e.providerId));
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();
      final googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;
      final googleAuthClient = await googleUser.authorizationClient
          .authorizationHeaders(['email']);

      final firebaseCrediential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuthClient!['Authorization']!,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        firebaseCrediential,
      );

      print("Estou lagado com o google");
      return userCredential.user;
    } catch (e, s) {
      print("Caiu na exception");
      print(e);
      print(s);
      throw AuthException(message: "Erro ao se autenticar com o google");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: "Erro ao sair da conta");
    }
  }
}
