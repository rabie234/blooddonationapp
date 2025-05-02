import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google Login Button
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const GoogleLoginButton({super.key, this.onLoginSuccess});

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the login
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Call the success callback if provided
      if (onLoginSuccess != null) {
        onLoginSuccess!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in with Google successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log in with Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      onPressed: () => _loginWithGoogle(context),
      icon: Image.asset(
        'assets/images/google_logo.png', // Add a Google logo image to your assets
        height: 20,
        width: 20,
      ),
      label: Text(
        'continue_with_google'.tr,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

/// Facebook Login Button
class FacebookLoginButton extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const FacebookLoginButton({super.key, this.onLoginSuccess});

  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      // Facebook login logic can be implemented here
      // For example, using the Facebook SDK or Firebase Authentication

      // Simulate a successful login for now
      if (onLoginSuccess != null) {
        onLoginSuccess!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in with Facebook successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log in with Facebook: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1877F2),
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => _loginWithFacebook(context),
      icon: Icon(Icons.facebook, size: 20),
      label: Text(
        'continue_with_facebook'.tr,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
