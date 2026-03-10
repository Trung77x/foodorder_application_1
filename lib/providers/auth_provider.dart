import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _parseFirebaseError(dynamic e) {
    String code = '';
    if (e is FirebaseAuthException) {
      code = e.code;
      debugPrint('FirebaseAuthException: code=${e.code}, message=${e.message}');
    } else {
      debugPrint('Auth error: $e');
    }
    switch (code) {
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu phải có ít nhất 6 ký tự';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Sai mật khẩu';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng';
      case 'too-many-requests':
        return 'Quá nhiều lần thử. Vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng';
      case 'operation-not-allowed':
        return 'Phương thức đăng nhập này chưa được bật trong Firebase Console';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa';
      default:
        if (e is FirebaseAuthException) {
          return 'Lỗi đăng nhập: ${e.message ?? e.code}';
        }
        return 'Lỗi không xác định. Vui lòng thử lại';
    }
  }

  AuthProvider() {
    _checkAuthStatus();
  }

  // === Lưu user lên Firestore ===
  Future<void> _saveUserToDatabase(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  // === Đọc user từ Firestore ===
  Future<UserModel?> _getUserFromDatabase(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('getUserFromDatabase error: $e');
    }
    return null;
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      // Thử đọc từ Realtime Database trước
      final dbUser = await _getUserFromDatabase(userId);
      if (dbUser != null) {
        _user = dbUser;
      } else {
        _user = UserModel(
          id: userId,
          name: prefs.getString('userName') ?? '',
          email: prefs.getString('userEmail') ?? '',
          phone: prefs.getString('userPhone') ?? '',
          address: prefs.getString('userAddress') ?? '',
          profileImage: prefs.getString('userProfileImage') ?? '',
        );
      }
      _isAuthenticated = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Đăng nhập bằng Firebase Auth (email/password)
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        _isLoading = false;
        _errorMessage = 'Không thể xác thực tài khoản';
        notifyListeners();
        return false;
      }

      // Firebase Auth thành công → xết user, Firestore lỗi không ảnh hưởng
      _user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? email.split('@').first,
        email: email,
        phone: '',
        address: '',
      );

      // Cố đọc từ Firestore (không bắt buộc)
      try {
        final dbUser = await _getUserFromDatabase(firebaseUser.uid);
        if (dbUser != null) _user = dbUser;
      } catch (_) {}

      // Cố lưu lên Firestore (không bắt buộc)
      _saveUserToDatabase(_user!);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userPhone', _user!.phone);

      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _parseFirebaseError(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi không xác định: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Tạo tài khoản Firebase Auth
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        _isLoading = false;
        _errorMessage = 'Không thể tạo tài khoản';
        notifyListeners();
        return false;
      }

      // Firebase Auth thành công
      _user = UserModel(
        id: firebaseUser.uid,
        name: name,
        email: email,
        phone: phone,
        address: '',
      );

      // Cố lưu lên Firestore (không bắt buộc)
      _saveUserToDatabase(_user!);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userPhone', _user!.phone);

      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _parseFirebaseError(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi không xác định: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userPhone');
    await prefs.remove('userProfileImage');

    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // === GOOGLE SIGN-IN ===
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? googleUser.displayName ?? '',
        email: firebaseUser.email ?? googleUser.email,
        phone: firebaseUser.phoneNumber ?? '',
        address: '',
        profileImage: firebaseUser.photoURL ?? googleUser.photoUrl ?? '',
      );

      // Lưu user lên Realtime Database
      await _saveUserToDatabase(_user!);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userPhone', _user!.phone);
      await prefs.setString('userProfileImage', _user!.profileImage);

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name, String phone, String address) async {
    try {
      _user = UserModel(
        id: _user!.id,
        name: name,
        email: _user!.email,
        phone: phone,
        address: address,
        profileImage: _user!.profileImage,
      );

      // Cập nhật lên Realtime Database
      await _saveUserToDatabase(_user!);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('userPhone', phone);
      await prefs.setString('userAddress', address);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
