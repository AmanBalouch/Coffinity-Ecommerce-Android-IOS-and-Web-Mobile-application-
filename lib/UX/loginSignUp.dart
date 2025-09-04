import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemobileapplicationandroid/UX/Providers/DBProvider.dart';
import 'package:coffeemobileapplicationandroid/UX/Providers/authProvider.dart';
import 'package:coffeemobileapplicationandroid/screens/homeScreen.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffeemobileapplicationandroid/UX/Database/DBHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginSignUp {
  static Future<bool> signUp(BuildContext context, String _email,
      String _password,String name) async {
    if (_email == "" || _password == "") {
      context.read<authProvider>().upgradeMessage(
          "Both fields must be filled.");
      return false;
    }
    else {
      UserCredential? usercredential;
      try {
        usercredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email, password: _password);
        await DBHelper.createUserDocument(usercredential.user!, name);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("login", true);
        // Provider.of<DBProvider>(context, listen: false).loadUserName();
        // Provider.of<DBProvider>(context, listen: false).loadEmail();
        String _userName=await DBHelper.fetchUserName();
        String _userEmail=await DBHelper.fetchEmail();
        await prefs.setString("userName",_userName);
        await prefs.setString("email", _userEmail);
        return true;
      }
      on FirebaseAuthException catch (ex) {
        context.read<authProvider>().upgradeMessage(
            ex.message ?? "Sign Up failed.");
        return false;
      }
    }
  }

  static Future<bool> logIn(BuildContext context, String _email,
      String _password) async {
    if (_email == "" || _password == "") {
      context.read<authProvider>().upgradeMessage(
          "Both fields must be filled.");
      return false;
    }
    else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email, password: _password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("login", true);
        String _userName=await DBHelper.fetchUserName();
        String _userEmail=await DBHelper.fetchEmail();
        await prefs.setString("userName",_userName);
        await prefs.setString("email", _userEmail);
        return true;
      } on FirebaseAuthException catch (ex) {
        context.read<authProvider>().upgradeMessage(
            ex.message ?? "Log In failed.");
        return false;
      }
    }
  }

  static Future<bool> forgotPassword(BuildContext context,
      String _email) async {
    if (_email == "") {
      context.read<authProvider>().upgradeMessage("Field must be filled.");
      return false;
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        context.read<authProvider>().upgradeMessage(
            "Reset email sent! Check your inbox.");
        return true;
      } on FirebaseAuthException catch (ex) {
        context.read<authProvider>().upgradeMessage(
            ex.message ?? "Reset failed.");
        return false;
      }
    }
  }
}