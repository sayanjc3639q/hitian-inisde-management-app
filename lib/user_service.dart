import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'generated/hitian_connector.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  final _connector = HitianConnectorConnector.instance;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QueryResult<GetUserData, GetUserVariables>>? _userDocSubscription;

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
  bool get isAdmin => (_userData.value?['role'] ?? _userData.value?['role']) == 'admin';

  void _startListening(String uid) {
    _userDocSubscription?.cancel();
    
    // Use Data Connect subscription
    _userDocSubscription = _connector.getUser(id: uid).ref().subscribe().listen((result) {
      _fetchingError.value = null;
      final user = result.data.user;
      if (user != null) {
        // Map GetUserUser to Map<String, dynamic> for UI compatibility
        _userData.value = {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'rollNumber': user.rollNumber,
          'domain': user.domain,
          'batch': user.batch,
          'profilePic': user.profilePic,
          'role': user.role,
          'createdAt': user.createdAt,
          // Add placeholders for counts which might still be in Firestore for now
          'ideasCount': 0,
          'tasksCount': 0,
          'eventsCount': 0,
        };
      } else {
        _fetchingError.value = "User not found in SQL database.";
        // Fallback: If not in SQL, it might be an old user not yet migrated.
        // We could trigger a migration here or just show the error.
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
