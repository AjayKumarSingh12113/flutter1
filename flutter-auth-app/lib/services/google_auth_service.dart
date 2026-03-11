import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google Login Result Model
class GoogleLoginResult {
  final bool success;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? errorMessage;

  GoogleLoginResult({
    required this.success,
    this.email,
    this.name,
    this.photoUrl,
    this.errorMessage,
  });
}

/// Google Authentication Service for Android
/// Handles Firebase Google Sign-In for Flutter Android app
class GoogleAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    serverClientId: '691717936126-qvhcvadfacn2jnm61eu18du863sjjhl6.apps.googleusercontent.com',
  );

  /// Sign in with Google
  /// Opens Google account picker and authenticates user
  /// Returns user details (email, name, photo)
  static Future<GoogleLoginResult> signInWithGoogle() async {
    try {
      // Check if already signed in and sign out first
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Trigger Google Sign-In - Opens account picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return GoogleLoginResult(
          success: false,
          errorMessage: 'Google Sign-In cancelled by user',
        );
      }

      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        return GoogleLoginResult(
          success: true,
          email: user.email,
          name: user.displayName,
          photoUrl: user.photoURL,
        );
      } else {
        return GoogleLoginResult(
          success: false,
          errorMessage: 'Failed to get user information from Firebase',
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Firebase authentication error';

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'Account exists with different credentials. Please use email login.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please try again. Make sure OAuth credentials are properly configured in Firebase Console.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not configured in Firebase Console. Please enable Google Sign-In provider.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = e.message ?? 'Firebase error occurred: ${e.code}';
      }

      return GoogleLoginResult(
        success: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      final errorStr = e.toString();
      
      // Handle specific Google API errors
      if (errorStr.contains('ApiException') && errorStr.contains('10:')) {
        return GoogleLoginResult(
          success: false,
          errorMessage: 'Configuration error: Google OAuth credentials not properly set up in Firebase Console. Please:\n1. Go to Firebase Console\n2. Enable Google Sign-In provider\n3. Add Android certificate fingerprint\n4. Download updated google-services.json',
        );
      }
      
      return GoogleLoginResult(
        success: false,
        errorMessage: 'Unexpected error: ${e.toString()}. Check Firebase Console OAuth configuration.',
      );
    }
  }

  /// Sign out from Google and Firebase
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error signing out: ${e.toString()}');
    }
  }

  /// Check if user is already signed in
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current signed-in user
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }
}
