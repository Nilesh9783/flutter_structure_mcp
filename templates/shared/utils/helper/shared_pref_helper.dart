import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:expense_tracker/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  //Keys
  static const String email = 'email';
  static const String isLoogedIn = 'isLoogedIn';
  final String appUDID = 'appUDID';
  final String deviceToken = 'deviceToken';
  static const String userType = 'userType';
  static const String userMobile = 'userMobile';
  static const String countryCode = 'countryCode';
  static const String lastLoginTime = 'lastLoginTime';
  static const String userUID = 'userUID';
  static const String orgID = 'orgID';
  static const String userProfileComplete = 'userProfileComplete';
  static const String isDarkMode = 'isDarkMode';
  // static const String userTypeTitle = 'userTypeTitle';
  static const String introScreenVisibleFirstTime =
      'introScreenVisibleFirstTime';
  static const String addVanceSecurityAllow = 'addVanceSecurityAllow';

  final IV iv = IV.fromLength(8);
  final Encrypter encrypter = Encrypter(Salsa20(Key.fromLength(32)));

  // For plain-text data
  Future<void> set(String key, dynamic value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    } else if (value is String) {
      sharedPreferences.setString(key, value);
    } else if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is int) {
      sharedPreferences.setInt(key, value);
    } else if (value is UserModel) {
      sharedPreferences.setString(key, jsonEncode(value));
    } else if (value is Timestamp) {
      sharedPreferences.setString(key, value.toString());
    }
  }

  //Method for get from any key
  Future<dynamic> get(String key, {dynamic defaultValue}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.get(key) ?? defaultValue;
  }

  //Example for get string
  Future<String> getString() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.get(deviceToken) as String? ?? '';
  }

  //Example for get bool
  Future<bool> isLoggedIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.get(isLoogedIn) as bool? ?? false;
  }

  Future<void> setEncrypted(String key, String value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(key, encrypter.encrypt(value).base64);
  }

  Future<String?> getEncrypted(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    Encrypted? encrypted = sharedPreferences.get(key) as Encrypted?;
    if (encrypted == null) return null;
    return encrypter.decrypt(encrypted, iv: iv);
  }

  Future<void> setUuid(String uuid) {
    return setEncrypted(appUDID, uuid);
  }

  Future<String?> getUuid() {
    return getEncrypted(appUDID);
  }

  Future<void> setToken(String uuid) async {
    return setEncrypted(appUDID, uuid);
  }

  Future<String?> getToken() async {
    return getEncrypted(appUDID);
  }

  // For logging out
  Future<void> deleteAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoogedIn);
    await prefs.remove(appUDID);
    await prefs.remove(deviceToken);
  }
}
