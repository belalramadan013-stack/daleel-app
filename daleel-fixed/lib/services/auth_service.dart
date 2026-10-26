import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// خدمة المصادقة مع حفظ الجلسة
class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthService() {
    _loadSavedUser();
  }

  /// تحميل المستخدم المحفوظ
  Future<void> _loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      if (userJson != null) {
        final data = jsonDecode(userJson);
        _currentUser = UserModel(
          id: data['id'],
          fullName: data['fullName'],
          email: data['email'],
          phone: data['phone'],
          accountType: data['accountType'] ?? 'individual',
          selectedCountry: data['selectedCountry'],
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  /// حفظ المستخدم
  Future<void> _saveUser() async {
    if (_currentUser == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode({
        'id': _currentUser!.id,
        'fullName': _currentUser!.fullName,
        'email': _currentUser!.email,
        'phone': _currentUser!.phone,
        'accountType': _currentUser!.accountType,
        'selectedCountry': _currentUser!.selectedCountry,
      }));
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  /// تسجيل الدخول
  Future<bool> login(String email, String password, {String accountType = 'individual'}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isNotEmpty && password.length >= 6) {
      // استخراج الاسم من البريد
      final name = email.split('@').first;
      
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: name,
        email: email,
        accountType: accountType,
      );
      
      await _saveUser();
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// إنشاء حساب
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    required String accountType,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
      accountType: accountType,
    );

    await _saveUser();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// تحديث الدولة
  void setSelectedCountry(String countryCode) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(selectedCountry: countryCode);
      _saveUser();
      notifyListeners();
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    notifyListeners();
  }
}
