
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // DAFTAR AKUN BARU DENGAN EMAIL DAN PASSWORD
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Akun gagal dibuat. Silakan coba kembali.');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name.trim(),
      'email': user.email,
      'username': '',
      'phone': '',
      'avatarUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // LOGIN DENGAN EMAIL DAN PASSWORD
  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // LOGIN DENGAN GOOGLE (FLUTTER WEB)
  Future<UserCredential> signInWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('email');

    final credential = await _auth.signInWithPopup(googleProvider);

    final user = credential.user;

    if (user == null) {
      throw Exception('Login Google gagal. Silakan coba kembali.');
    }

    // Periksa apakah profil pengguna sudah ada di Firestore.
    final userRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userRef.get();

    // Buat profil hanya jika pengguna belum memiliki dokumen.
    if (!userDoc.exists) {
      await userRef.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'username': '',
        'phone': '',
        'avatarUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // PENGGUNA YANG SEDANG LOGIN
  User? get currentUser => _auth.currentUser;

  // MEMANTAU STATUS LOGIN
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}