import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot>? _userDocSubscription;

  UserService._internal() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        _userData.value = null;
        _fetchingError.value = null;
        _userDocSubscription?.cancel();
        _userDocSubscription = null;
      } else {
        _startListening(user.uid);
      }
    });
  }

  final ValueNotifier<Map<String, dynamic>?> _userData = ValueNotifier(null);
  final ValueNotifier<String?> _fetchingError = ValueNotifier(null);
  
  ValueNotifier<Map<String, dynamic>?> get userDataNotifier => _userData;
  ValueNotifier<String?> get fetchingErrorNotifier => _fetchingError;
  
  Map<String, dynamic>? get currentUserData => _userData.value;
  bool get isAdmin => _userData.value?['isAdmin'] ?? false;

  void _startListening(String uid) {
    _userDocSubscription?.cancel();
    _userDocSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      _fetchingError.value = null;
      if (snapshot.exists) {
        _userData.value = snapshot.data() as Map<String, dynamic>;
      } else {
        _fetchingError.value = "User document does not exist in Firestore.";
      }
    }, onError: (error) {
      _fetchingError.value = error.toString();
    });
  }

  void dispose() {
    _authSubscription?.cancel();
    _userDocSubscription?.cancel();
  }
}
