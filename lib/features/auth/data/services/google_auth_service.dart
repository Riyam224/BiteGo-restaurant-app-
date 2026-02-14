import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restaurant_app/core/utils/app_logger.dart';

/// Google Authentication Service
/// Handles Firebase Authentication with Google Sign-In
/// Follows Single Responsibility Principle - only handles Google OAuth flow
/// Uses google_sign_in v7.0+ API (singleton instance and authenticate method)
class GoogleAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  /// Sign in with Google
  /// Returns Firebase ID token that can be used to authenticate with backend
  /// Throws exception if sign in fails or is cancelled
  Future<String> signInWithGoogle() async {
    try {
      AppLogger.info('Starting Google Sign-In flow');

      // Try lightweight authentication first (silent sign-in), fallback to interactive
      late GoogleSignInAccount googleUser;

      // attemptLightweightAuthentication returns GoogleSignInAccount? (nullable)
      final silentUser = await _googleSignIn.attemptLightweightAuthentication();

      if (silentUser != null) {
        AppLogger.info('Silent sign-in successful');
        googleUser = silentUser;
      } else {
        AppLogger.info('Silent sign-in failed, falling back to interactive sign-in');
        // authenticate returns GoogleSignInAccount (non-nullable) or throws
        googleUser = await _googleSignIn.authenticate();
      }

      AppLogger.info('Google user signed in: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential using the ID token
      // Note: google_sign_in v7.0+ only provides idToken
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Get the Firebase ID token
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        AppLogger.error('Failed to get Firebase ID token');
        throw Exception('Failed to get authentication token');
      }

      AppLogger.auth(
          'Firebase authentication successful for: ${googleUser.email}');
      return idToken;
    } on firebase_auth.FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth error: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign out from Google and Firebase
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.disconnect(),
        _firebaseAuth.signOut(),
      ]);
      AppLogger.info('Google and Firebase sign out successful');
    } catch (e) {
      AppLogger.error('Sign out error: $e');
      rethrow;
    }
  }

  /// Handle Firebase Authentication exceptions
  Exception _handleFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return Exception(
            'An account already exists with the same email but different sign-in credentials');
      case 'invalid-credential':
        return Exception('The credential is malformed or has expired');
      case 'operation-not-allowed':
        return Exception('Google Sign-In is not enabled for this project');
      case 'user-disabled':
        return Exception('This user account has been disabled');
      case 'user-not-found':
        return Exception('No user found with this credential');
      case 'wrong-password':
        return Exception('Invalid password');
      case 'invalid-verification-code':
        return Exception('Invalid verification code');
      case 'invalid-verification-id':
        return Exception('Invalid verification ID');
      default:
        return Exception(e.message ?? 'An authentication error occurred');
    }
  }
}

