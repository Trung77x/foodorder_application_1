import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      _isAuthenticated = true;
      _user = UserModel(
        id: userId,
        name: prefs.getString('userName') ?? '',
        email: prefs.getString('userEmail') ?? '',
        phone: prefs.getString('userPhone') ?? '',
        address: prefs.getString('userAddress') ?? '',
        profileImage: prefs.getString('userProfileImage') ?? '',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@').first,
        email: email,
        phone: '',
        address: '',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userPhone', _user!.phone);

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

  Future<bool> signup(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        address: '',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userPhone', _user!.phone);

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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userPhone');

    _user = null;
    _isAuthenticated = false;
    notifyListeners();
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
