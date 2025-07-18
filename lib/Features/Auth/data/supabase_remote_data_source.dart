// import 'dart:async';
// import 'dart:io';

// import 'package:hive/hive.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:task_wizard/Features/Auth/Presentation/AuthBloc/auth_bloc.dart';
// import 'package:task_wizard/Features/Auth/data/auth_remote_data_source.dart';
// import 'package:task_wizard/Features/Auth/data/user.dart';
// class AuthException implements Exception {
//   final String message;
//   final String code;

//   AuthException(this.message, this.code);

//   @override
//   String toString() => 'AuthException: $message (Code: $code)';
// }
// class NetworkException extends AuthException {
//   NetworkException(String message) : super(message, 'NETWORK_ERROR');
// }

// class UserNotFoundException extends AuthException {
//   UserNotFoundException() : super('User not found', 'USER_NOT_FOUND');
// }

// class InvalidCredentialsException extends AuthException {
//   InvalidCredentialsException()
//     : super('Invalid email or password', 'INVALID_CREDENTIALS');
// }

// class EmailNotVerifiedException extends AuthException {
//   EmailNotVerifiedException()
//     : super('Email not verified', 'EMAIL_NOT_VERIFIED');
// }

// class UserAlreadyExistsException extends AuthException {
//   UserAlreadyExistsException()
//     : super('User already exists', 'USER_ALREADY_EXISTS');
// }

// class GoogleSignInCancelledException extends AuthException {
//   GoogleSignInCancelledException()
//     : super('Google sign in was cancelled', 'GOOGLE_SIGNIN_CANCELLED');
// }

// class DatabaseException extends AuthException {
//   DatabaseException(String message) : super(message, 'DATABASE_ERROR');
// }

// class SessionExpiredException extends AuthException {
//   SessionExpiredException() : super('Session has expired', 'SESSION_EXPIRED');
// }
// class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
//   final SupabaseClient _supabase;
//   final GoogleSignIn _googleSignIn;

//   SupabaseAuthRemoteDataSource({SupabaseClient? supabaseClient})
//     : _supabase = supabaseClient ?? Supabase.instance.client,
//       _googleSignIn = GoogleSignIn();

//   @override
//   Future<String> checkIfFirstTime() async {
//     try {
//       final user = _supabase.auth.currentUser;
//       final session = _supabase.auth.currentSession;

//       final box = await Hive.openBox<UserModel>('userBox');
//       final pendingUser = box.get('pendingUser');

//       if (pendingUser != null) {
//         return '${pendingUser.email}E';
//       }
//       else if (user == null && session == null) {
//         return 'LoginPage';
//       } 
      

//       final response =
//           await _supabase
//               .from('users')
//               .select('id')
//               .eq('id', user!.id)
//               .maybeSingle();

//       if (response == null) {
//         // TODO: Create onboarding screens later
//         return 'LoginPage';
//       }

//       return 'HomePage';
//     } on PostgrestException catch (e) {
//       throw DatabaseException('Failed to check user in database: ${e.message}');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } on AuthException {
//       if (_supabase.auth.currentUser == null) {
//         throw SessionExpiredException();
//       }
//       rethrow;
//     } catch (e) {
//       throw AuthException('Failed to check user status: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   @override
//   Future<UserCredential> authenticateUser(
//     String email,
//     String password,
    
//   ) async {
//     try {
//       if (email.isEmpty || password.isEmpty) {
//         throw InvalidCredentialsException();
//       }

//       final response = await _supabase.auth.signUp(
//         email: email,
//         password: password,
//       );

//       if (response.user == null) {
//         throw InvalidCredentialsException();
//       }

//       // Save user locally in Hive (not in Supabase yet)
//       final box = await Hive.openBox<UserModel>('userBox');
//       await box.put('pendingUser', user.copyWith(iid: response.user!.id));
//       box.close();
//       return UserCredential(user: response.user!, session: response.session);
//     } on AuthException catch (e) {
//       if (e.message.contains('Invalid login credentials')) {
//         throw InvalidCredentialsException();
//       } else if (e.message.contains('Email not confirmed')) {
//         throw EmailNotVerifiedException();
//       } else if (e.message.contains('User not found')) {
//         throw UserNotFoundException();
//       }
//       throw AuthException('Authentication failed: ${e.message}', 'AUTH_ERROR');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Authentication failed: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   @override
//   Future<void> addUser(UserModel user) async {
//     try {
//       if (user.email.isEmpty) {
//         throw AuthException('Email cannot be empty', 'INVALID_DATA');
//       }

//       // Get the current user's ID and ensure it matches
//       final currentUser = _supabase.auth.currentUser;
//       if (currentUser == null) {
//         print('This did not worl');
//         throw AuthException('User must be authenticated', 'NOT_AUTHENTICATED');
//       }

//       // Ensure the user model has the correct ID
//       final userWithCorrectId = user.copyWith(iid: currentUser.id);

//       await _supabase.from('users').insert(userWithCorrectId.toJson());
//     } on PostgrestException catch (e) {
//       if (e.code == '23505') {
//         // Unique constraint violation
//         throw UserAlreadyExistsException();
//       }
//       throw DatabaseException('Failed to save user data: ${e.message}');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Failed to add user: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   @override
//   Future<void> signIn(String email, String password) async {
//     try {
//       if (email.isEmpty || password.isEmpty) {
//         throw InvalidCredentialsException();
//       }

//       final response = await _supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );

//       if (response.user == null) {
//         throw InvalidCredentialsException();
//       }
//     } on AuthException catch (e) {
//       if (e.message.contains('Invalid login credentials')) {
//         throw InvalidCredentialsException();
//       } else if (e.message.contains('Email not confirmed')) {
//         throw EmailNotVerifiedException();
//       } else if (e.message.contains('User not found')) {
//         throw UserNotFoundException();
//       }
//       throw AuthException('Sign in failed: ${e.message}', 'AUTH_ERROR');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Sign in failed: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   @override
//   Future<void> emailVerification() async {
//     try {
//       final session = _supabase.auth.currentSession;
//       final user = _supabase.auth.currentUser;

//       if (user == null || session == null) {
//         throw SessionExpiredException();
//       }

//       // Check if email is verified
//       await _supabase.auth
//           .refreshSession(); // Refresh the session to get latest info
//       final refreshedUser = _supabase.auth.currentUser;

//       if (refreshedUser?.emailConfirmedAt == null) {
//         print('Email still not verified.');
//         return;
//       }

//       // Email is verified. Retrieve user from Hive and insert into Supabase DB
//       final box = await Hive.openBox<UserModel>('userBox');
//       final pendingUser = box.get('pendingUser');

//       if (pendingUser != null) {
//         await addUser(pendingUser);
//         await box.delete('pendingUser'); // Remove after successful insert
//       }
//       box.close();
//     } on AuthException catch (e) {
//       if (e.message.contains('rate limit')) {
//         throw AuthException(
//           'Too many requests. Please try again later',
//           'RATE_LIMIT',
//         );
//       }
//       throw AuthException(
//         'Email verification failed: ${e.message}',
//         'VERIFICATION_ERROR',
//       );
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Email verification failed: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   @override
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         throw GoogleSignInCancelledException();
//       }

//       final googleAuth = await googleUser.authentication;

//       if (googleAuth.idToken == null) {
//         throw AuthException(
//           'Failed to get Google ID token',
//           'GOOGLE_TOKEN_ERROR',
//         );
//       }

//       final response = await _supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken,
//       );

//       if (response.user == null) {
//         throw AuthException(
//           'Google authentication failed',
//           'GOOGLE_AUTH_ERROR',
//         );
//       }

//       // Check if user exists in DB
//       final existingUser =
//           await _supabase
//               .from('users')
//               .select()
//               .eq('id', response.user!.id)
//               .maybeSingle();

//       if (existingUser == null) {
//         final userModel = UserModel(
//           response.user!.id,
//           email: response.user!.email ?? '',
//           userName:
//               response.user!.userMetadata?['full_name'] ??
//               response.user!.email?.split('@')[0] ??
//               'User',
//           phoneNumber: response.user!.phone ?? '',
//           profilePicture: response.user!.userMetadata?['avatar_url'] ?? '',
//         );
//         await addUser(userModel);
//       }

//       return UserCredential(user: response.user!, session: response.session);
//     } on GoogleSignInCancelledException {
//       rethrow;
//     } on AuthException {
//       rethrow;
//     } on PlatformException catch (e) {
//       if (e.code == GoogleSignIn.kSignInCanceledError) {
//         throw GoogleSignInCancelledException();
//       }
//       throw AuthException(
//         'Google sign in failed: ${e.message}',
//         'GOOGLE_PLATFORM_ERROR',
//       );
//     } on PostgrestException catch (e) {
//       throw DatabaseException('Failed to save Google user data: ${e.message}');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Google sign in failed: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   Future<void> signUp(String email, String password, UserModel user) async {
//     try {
//       if (email.isEmpty || password.isEmpty) {
//         throw AuthException(
//           'Email and password cannot be empty',
//           'INVALID_DATA',
//         );
//       }

//       if (password.length < 6) {
//         throw AuthException(
//           'Password must be at least 6 characters',
//           'WEAK_PASSWORD',
//         );
//       }

//       final response = await _supabase.auth.signUp(
//         email: email,
//         password: password,
//       );
//       await _supabase.auth.signInWithPassword(email: email, password: password);

//       if (response.user == null) {
//         throw AuthException('Failed to create account', 'SIGNUP_FAILED');
//       }

//       // Add user to our users table with the auth user ID
//       final userWithAuthId = UserModel(
//         response.user!.id,
//         email: user.email,
//         userName: user.userName,
//         phoneNumber: user.phoneNumber,
//         password: null, // Don't store password in users table
//         profilePicture: user.profilePicture,
//       );

//       await addUser(userWithAuthId);
//     } on AuthException catch (e) {
//       if (e.message.contains('User already registered')) {
//         throw UserAlreadyExistsException();
//       } else if (e.message.contains('weak password')) {
//         throw AuthException('Password is too weak', 'WEAK_PASSWORD');
//       } else if (e.message.contains('invalid email')) {
//         throw AuthException('Invalid email format', 'INVALID_EMAIL');
//       }
//       rethrow;
//     } on PostgrestException catch (e) {
//       throw DatabaseException('Failed to save user data: ${e.message}');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Sign up failed: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _supabase.auth.signOut();

//       final isGoogleSignedIn = await _googleSignIn.isSignedIn();
//       if (isGoogleSignedIn) {
//         await _googleSignIn.signOut();
//       }
//     } on AuthException catch (e) {
//       throw AuthException('Sign out failed: ${e.message}', 'SIGNOUT_ERROR');
//     } on PlatformException catch (e) {
//       throw AuthException(
//         'Google sign out failed: ${e.message}',
//         'GOOGLE_SIGNOUT_ERROR',
//       );
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Sign out failed: $e', 'UNKNOWN_ERROR');
//     }
//   }

//   Future<UserModel?> getCurrentUser() async {
//     try {
//       final authUser = _supabase.auth.currentUser;
//       if (authUser == null) {
//         return null;
//       }

//       final userData =
//           await _supabase
//               .from('users')
//               .select()
//               .eq('id', authUser.id)
//               .maybeSingle();

//       if (userData == null) {
//         return null;
//       }

//       return UserModel.fromMap(userData);
//     } on PostgrestException catch (e) {
//       throw DatabaseException('Failed to fetch user data: ${e.message}');
//     } on SocketException {
//       throw NetworkException('No internet connection available');
//     } on TimeoutException {
//       throw NetworkException('Request timeout - please check your connection');
//     } catch (e) {
//       throw AuthException('Failed to get current user: $e', 'UNKNOWN_ERROR');
//     }
//   }
// }

// // Custom UserCredential class to match your interface
// class UserCredential {
//   final User user;
//   final Session? session;

//   UserCredential({required this.user, this.session});
// }

// // Custom UserCredential class to match your interface
