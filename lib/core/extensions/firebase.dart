import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

extension StreamChatContext on BuildContext {
  /// Get user token.
  String? get userType => FirebaseAuth.instance.currentUser!.displayName;

  /// get user id
  String? get userUid => FirebaseAuth.instance.currentUser!.uid;

  /// get the current user
  User? get logedInUser => FirebaseAuth.instance.currentUser;
}
