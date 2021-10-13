// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger_clone/screens/home.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helperfunctions/sharedpref_helper.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    SharedPreferenceHelper()
        .saveDisplayName(userDetails!.displayName as String);

    SharedPreferenceHelper().saveProfilePicUrl(userDetails.photoURL as String);

    SharedPreferenceHelper().saveUserEmail(userDetails.email as String);

    SharedPreferenceHelper().saveUserId(userDetails.uid);

    Map<String, dynamic> userInfoMap = {
      "email": userDetails.email as String,
      "username": userDetails.email!.replaceAll("@gmail.com", ""),
      "name": userDetails.displayName as String,
      "imgUrl": userDetails.photoURL as String
    };
    DatabaseMethods().addUserInfoToDatabase(userDetails.uid, userInfoMap).then(
        (value) => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  Future signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    await auth.signOut();
  }
}
