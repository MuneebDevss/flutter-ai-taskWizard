import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:task_wizard/Features/Auth/data/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> checkIfFirstTime();
  Future<UserCredential> authenticateUser(String email, String password);
  Future<void> addUser(UserModel user);
  Future<void> signIn(String email, String password);
  Future<void> emailVerification();
  Future<UserCredential?> signInWithGoogle();
}

class FirebaseRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Isar isar;
  FirebaseRemoteDataSourceImpl({required this.isar});
  User? getUser() => auth.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void startListening() {
    _db
        .collection('users')
        .doc(getUser()!.uid)
        .collection('tasks')
        .snapshots()
        .listen(
          (snapshot) async {
            try {
              print('\n\n\nobject\n\n\n');

              final firestoreTasks =
                  snapshot.docs
                      .map((doc) => NormalTask.fromMap(doc.data()))
                      .toList();

              final localTasks = await isar.normalTasks.where().findAll();
              final localMap = {for (var t in localTasks) t.id: t};
              
              // Get Firestore task IDs for comparison
              final firestoreIds = firestoreTasks.map((e) => e.id).toSet();

              await isar.writeTxn(() async {
                // Prepare tasks for bulk operation - ensure no duplicates
                final tasksToUpdate = <NormalTask>[];
                final processedIds = <String>{};

                for (final fTask in firestoreTasks) {
                  if (!processedIds.contains(fTask.id)) {
                    final local = localMap[fTask.id];
                    tasksToUpdate.add(
                      local != null
                          ? fTask.copyWith(isarId: local.isarId)
                          : fTask,
                    );
                    processedIds.add(fTask.id);
                  }
                }
                
                // Bulk update/insert
                await isar.normalTasks.putAll(tasksToUpdate);

                // Delete tasks that no longer exist in Firestore
                for (final id in localMap.keys.toSet().difference(
                  firestoreIds,
                )) {
                  await isar.normalTasks.delete(localMap[id]!.isarId);
                }
              });
            } catch (e) {
              print('Error syncing tasks: $e');
              // Handle error appropriately (show user notification, retry, etc.)
            }
          },
          onError: (error) {
            print('Firestore listener error: $error');
            // Handle stream errors (network issues, permission errors, etc.)
          },
        );
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );
      return userCredential;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<String> checkIfFirstTime() async {
    try {
      Box box;
      if (!Hive.isBoxOpen('checkBox')) {
        final appDocumentDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDir.path);
      }
      box = await Hive.openBox('checkBox');
      bool? check = box.get('check');

      if (check == null) {
        await box.put('check', true);
        box.close();
        // we will deal with on boardiing later
        return 'LoginPage';
      }
      box.close();
      if (auth.currentUser != null) {
        if (auth.currentUser!.emailVerified == false) {
          return '${auth.currentUser!.email!}E';
        } else {
          startListening();
          return 'HomePage';
        }
      }

      return 'LoginPage';
    } catch (e) {
      throw Exception('Failed: $e'); // Provide a more specific error message
    }
  }

  @override
  Future<UserCredential> authenticateUser(String email, String password) async {
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> addUser(UserModel user) async {
    try {
      await _db.collection('User').doc(user.id).set(user.toJson());
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided for that user.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        default:
          throw 'Sign in failed. Please try again.';
      }
    } catch (e) {
      throw 'An error occurred. Please try again.';
    }
  }

  @override
  Future<void> emailVerification() async {
    try {
      await auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific exceptions
      if (e.code == 'account-exists-with-different-credential') {
        throw 'account-exists-with-different-credential';
      } else if (e.code == 'operation-not-allowed') {
        throw 'operation-not-allowed';
      } else if (e.code == 'user-disabled') {
        throw 'user-disabled';
      } else if (e.code == 'user-not-found') {
        throw 'user-not-found';
      }
    } catch (e) {
      // Handle generic exceptions
      throw ('Exception: $e');
    }
  }
}
