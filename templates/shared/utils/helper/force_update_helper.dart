import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/app_setting_model.dart';

import 'package:expense_tracker/utils/common/firebase_constant.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Future<String> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  //get persnal user info data
  Stream<AppSettingModel?> getAppSettingInfo() {
    return firestore
        .collection(FirebaseCollection.appSettingData)
        .snapshots()
        .map(appSetingFromSnapShot)
        // ignore: body_might_complete_normally_catch_error
        .handleError((onError) {
      // kNavigatorKey.currentContext?.showError('$onError');
      debugPrint('----  ${onError.toString()} -----');
    });
  }

  AppSettingModel? appSetingFromSnapShot(QuerySnapshot snapshot) {
    final AppSettingModel? userModel;
    if (snapshot.docs.isEmpty) {
      return null;
    } else {
      userModel = (AppSettingModel.fromDocumentSnapshot(snapshot.docs.first));
      return userModel;
    }
  }
}
