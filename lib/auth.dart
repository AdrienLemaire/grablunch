import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;


Future<Null> ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null)
    // Attempt to sign in a previously authenticated user
    user = await googleSignIn.signInSilently();
  if (user == null)  {
    // Start interactive sign-in process
    await googleSignIn.signIn();
    analytics.logLogin();
  }
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
      await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}

