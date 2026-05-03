import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'generated/hitian_connector.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _connector = HitianConnectorConnector.instance;

  // Stream for auth state changes
  Stream<User?> get user => _auth.authStateChanges();

  // Sign up with email & password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String rollNumber,
    required String domain,
    required int batch,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Create a new document for the user in Firestore (keep for now)
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'rollNumber': rollNumber,
          'domain': domain,
          'batch': batch,
          'createdAt': FieldValue.serverTimestamp(),
          'ideasCount': 0,
          'tasksCount': 0,
          'eventsCount': 0,
        });

        // ALSO: Create user in SQL via Data Connect
        await _connector.upsertUser(
          id: user.uid,
          name: name,
          email: email,
        )
        .rollNumber(rollNumber)
        .domain(domain)
        .batch(batch)
        .execute();
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  // Sign in with email & password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      return null;
    }
  }

  // Update user details
  Future<void> updateUserDetails({
    required String uid,
    required String name,
    required String rollNumber,
    required String domain,
    required int batch,
  }) async {
    // Update Firestore
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'rollNumber': rollNumber,
      'domain': domain,
      'batch': batch,
    });

    // Update SQL
    await _connector.upsertUser(
      id: uid,
      name: name,
      email: _auth.currentUser?.email ?? '',
    )
    .rollNumber(rollNumber)
    .domain(domain)
    .batch(batch)
    .execute();
  }

  // Update profile picture
  Future<void> updateProfilePicture(String uid, String? url) async {
    // Update Firestore
    await _firestore.collection('users').doc(uid).update({
      'profilePic': url,
    });

    // Update SQL
    await _connector.updateProfilePic(id: uid).url(url).execute();
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
