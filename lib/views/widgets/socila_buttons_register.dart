import 'dart:developer';

import 'package:blood_donation_app/controllers/registration_controller/login_controller.dart';
import 'package:blood_donation_app/utils/location_getter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google Login Button
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onLoginSuccess;
  final bool? isDonor;
  const GoogleLoginButton({super.key, this.onLoginSuccess, this.isDonor});

  Future<void> _loginWithGoogle(BuildContext context) async {
    final LoginController loginController = Get.put(LoginController());
    loginController.isLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the login
        return;
      }
      final location = await getCurrentLocation();
      if (location == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Location not available')),
        // );
        return; // Stop the sign-up process if location is not available
      }

      loginController
          .socialLogin(
              googleUser.email,
              googleUser.displayName ?? 'Guest',
              'google',
              location['longitude'] ?? 0.0,
              location['latitude'] ?? 0.0,
              isDonor)
          .then((value) {
        if (value) {
          Get.offAllNamed('/home');
          //  ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Logged in with Google successfully!')),
          // );
        }
      });

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('credenial: ${credential.toString()}');
      // Sign in to Firebase with the Google credential
      UserCredential currentUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log('currentUser: ${currentUser.user?.displayName}');
      // Call the success callback if provided
      if (onLoginSuccess != null) {
        onLoginSuccess!();
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Logged in with Google successfully!')),
      // );
    } catch (e) {
      log("$e");
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
// class FacebookLoginButton extends StatelessWidget {
//   final VoidCallback? onLoginSuccess;
//   final bool? isDonor;

//   const FacebookLoginButton({super.key, this.onLoginSuccess, this.isDonor});

//   Future<void> _loginWithFacebook(BuildContext context) async {
//     final LoginController loginController = Get.put(LoginController());
//     final fb = FacebookAuth.instance;

//     try {
//       await fb.logOut(); // Ensure clean login

//       final LoginResult res = await fb.login();

//       switch (res.status) {
//         case LoginStatus.success:
//           final AccessToken fbAccessToken = res.accessToken!;
//           final userData = await fb.getUserData();

//           final name = userData['name'] ?? 'Guest';
//           final email = userData['email'] ?? 'no_email@facebook.com';

//           final location = await getCurrentLocation();
//           if (location == null) return;

//           final OAuthCredential credential =
//               FacebookAuthProvider.credential(fbAccessToken.tokenString);
//           await FirebaseAuth.instance.signInWithCredential(credential);

//           final success = await loginController.socialLogin(
//             email,
//             name,
//             'facebook',
//             location['longitude'] ?? 0.0,
//             location['latitude'] ?? 0.0,
//             isDonor,
//           );

//           if (success) {
//             if (onLoginSuccess != null) onLoginSuccess!();
//             Get.offAllNamed('/home');
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Facebook login failed at server auth.')),
//             );
//           }
//           break;

//         case LoginStatus.cancelled:
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Login cancelled by user')),
//           );
//           break;

//         case LoginStatus.failed:
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Facebook login failed: ${res.message}')),
//           );
//           break;

//         default:
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Unexpected Facebook login error')),
//           );
//           break;
//       }
//     } catch (e) {
//       log("Facebook login error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to log in with Facebook: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.white,
//         backgroundColor: Color(0xFF1877F2),
//         padding: EdgeInsets.symmetric(vertical: 15),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       onPressed: () => _loginWithFacebook(context),
//       icon: Icon(Icons.facebook, size: 20, color: Colors.white),
//       label: Text(
//         'continue_with_facebook'.tr,
//         style: TextStyle(fontSize: 16),
//       ),
//     );
//   }
// }
