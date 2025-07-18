import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_wizard/Features/Auth/data/auth_remote_data_source.dart';

import 'package:fpdart/fpdart.dart';
import 'package:task_wizard/Features/Auth/data/user.dart';

class AuthRepository {
  final FirebaseRemoteDataSourceImpl impl;

  AuthRepository({required this.impl});
  
  Future<Either<String, bool>> googleSignIn() async {
    try {
      final userCredential = await impl.signInWithGoogle();
      User? user;
      if (userCredential != null) {
        user = userCredential.user;
      }
      if (user != null) {
        UserModel newUser = UserModel(
          user.uid,
          email: user.email ?? '',
          userName: user.displayName ?? user.email?.split('@')[0] ?? 'User',
          phoneNumber: user.phoneNumber ?? '',
          profilePicture: user.photoURL ?? '',
        );
        await impl.addUser(newUser);
      }
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> emailVerification() async {
    try {
      await impl.emailVerification();
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserModel>> authenticateUser(
    String email,
    String password,
    String phone,
    String userName,
  ) async {
    try {
      final userId = await impl.authenticateUser(email, password);
      final UserModel user = UserModel(
        userId.user!.uid,
        email: email,
        userName: userName,
        phoneNumber: phone,
        password: password,
        profilePicture: '',
      );
      await impl.addUser(user);

      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> checkIfFirstTime() async {
    try {
      return Right(await impl.checkIfFirstTime());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> signIn(String email, String password) async {
    try {
      await impl.signIn(email, password);
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
