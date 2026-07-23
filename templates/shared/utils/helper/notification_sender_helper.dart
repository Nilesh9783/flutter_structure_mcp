import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/notification_model.dart';
import 'package:expense_tracker/model/notifications/notification_payload.dart';
import 'package:expense_tracker/model/trasaction_add_expense_model.dart';
import 'package:expense_tracker/model/user_model.dart';
import 'package:expense_tracker/screens/transaction/detail_transaction/transaction_detail.dart';
import 'package:expense_tracker/services/common_services.dart';
import 'package:expense_tracker/services/notification_services.dart';
import 'package:expense_tracker/services/transaction_services.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/common/config.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/helpers/shared_pref_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import '../../screens/profile/manage_user_grp_list/main_user_group_tab_pages/manage_user_grp_userlist_screen.dart';
import '../common/env.dart';

class NotificationSenderHelper {
  NotificationServices notificationServices = NotificationServices();

  BehaviorSubject<bool> isNotificationRecived =
      BehaviorSubject<bool>.seeded(false);

  // final messaging = FirebaseMessaging.instance;
  // Future<void> notificationTapBackground(NotificationResponse response) async {
  //   await Firebase.initializeApp();

  //   Future.delayed(const Duration(seconds: 3), () {
  //     kNavigatorKey.currentContext?.showError("Notification Error");
  //   });
  // }

  String? token = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> setupSenderService() async {
    // await Firebase.initializeApp();
    //  await FirebaseMessaging.instance.getInitialMessage();
    if (Platform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    }
    requestPermission();
    deviceToken = await FirebaseMessaging.instance.getToken();

    initInfo();
    debugPrint('MObile notification $deviceToken');
    // send(
    //     token:
    //         'esGytbitSWyRcvQlH7n1pH:APA91bEAl5_0pMtnKCTU4R4YmUs8kNPykb0qiCU3DfX7NlW9O1RB7uAMxkV1vQ9wwcqQe1QUZpN6BShDqkrjP97U4FeTRS8-SvzUYwYpiS6rPs2Txl73G0eLnlEuoS46K2OGPTgXKAOR',
    //     title: "MObile notification",
    //     body: "body");
  }

  requestPermission() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Permission granted");
      try {
        if (deviceToken?.isNotEmpty ?? false) {
          deviceToken = await FirebaseMessaging.instance.getToken();
        }
      } on Exception {
        // TODO
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("provisional Permission granted");
    } else {
      debugPrint("rejected");
    }
  }

  // getToken() {
  //   FirebaseMessaging.instance.getToken().then((value) {
  //     token = value;
  //     debugPrint("$token token");
  //   });
  // }

  initInfo() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHanderler);
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) async {},
    );
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // this is use for forgorund notifictaon
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        if ((payload.payload ?? '').isNotEmpty) {
          NotificationBodyPayload notificationBodyPayload =
              notificationBodyPayloadFromJson(payload.payload ?? '');
          notificationRedireactionHandeler(
              notificationBodyPayload: notificationBodyPayload);
        }

        debugPrint('statement1 $payload');
        try {
          // ignore: unnecessary_null_comparison
          if (payload != null) {
          } else {}
        } catch (e) {
          return;
        }
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        NotificationBodyPayload notificationBodyPayload =
            notificationBodyPayloadFromJson(jsonEncode(message.data));
        aGeneralBloc.notificationBodyPayload = notificationBodyPayload;
        // notificationRedireactionHandeler(
        //     notificationBodyPayload: notificationBodyPayload);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      debugPrint('Firebase on messsage $event');
      isNotificationRecived.add(true);

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          '',
          htmlFormatBigText: true,
          contentTitle: event.notification?.title.toString(),
          htmlFormatContent: true);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('dbfood', 'EXPEANSE_TRACKER_CHANNEL',
              channelDescription: 'EXPEANSE_TRACKER_CHANNEL_DISCRIPTION',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);

      DarwinNotificationDetails darwinNotificationDetails =
          const DarwinNotificationDetails();

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);

      flutterLocalNotificationsPlugin.show(
          event.notification.hashCode,
          event.notification?.title.toString(),
          '', //(event.notification?.body ?? "Body").toString(),
          notificationDetails,
          payload: jsonEncode(event.data));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ignore: avoid_print

      isNotificationRecived.add(true);
      debugPrint('A new onMessageOpenedApp event was published!');

      NotificationBodyPayload notificationBodyPayload =
          notificationBodyPayloadFromJson(jsonEncode(message.data));
      // notificationRedireactionHandeler(
      //     notificationBodyPayload: notificationBodyPayload);
      aGeneralBloc.notificationBodyPayload = notificationBodyPayload;
    });
  }

  Future<void> send(
      {required String token,
      required NotificationBodyPayload body,
      required String title}) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=${env.authKey}'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': body.toJson(),
            // 'data': <String, dynamic>{
            //   'click_action': 'Flutter_screen_redriection',
            //   'status': 'done',
            //   'body': ,
            //   'title': title,
            // },
            'notification': <String, dynamic>{
              'title': title,
              "body": '',
              'android_channer_id': "dbfood"
            },
            "to": token
          }));
    } catch (e) {
      debugPrint(" Firebase $e");
    }
  }

  // sendPushNotifation() async {
  //   await FirebaseMessaging.instance.sendMessage(
  //     to: '',
  //     data: {"key": "from mobile"},
  //     messageId: "Messgae id",
  //     messageType: "From system",
  //   );
  // }

  Future<void> notificationSend(
      {required String reciverId,
      required NotificationBodyPayload body,
      required String title,
      bool? interNalSent = true}) async {
    final CommonServices commonServices = CommonServices();
    try {
      final DocumentSnapshot? documentSnapshot =
          await commonServices.getUserForToken(reciverId);
      //if (Platform.isAndroid) {
      if (interNalSent ?? false) {
        NotificationModel notificationModel = NotificationModel(
            message: title,
            reciverProfileId: body.reciverProfileId,
            senderId: body.senderId,
            senderName: body.senderName,
            reciverId: reciverId,
            transactionId: body.trascationId,
            notificationType: body.notificationType,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
            isRead: false);
        notificationServices.saveNotificationFirebase(
            notificationModel: notificationModel,
            onSuccess: (val) {},
            onError: (val) {});
      }
      if (documentSnapshot != null && documentSnapshot.data() != null) {
        final UserModel userModel =
            UserModel.fromDocumentSnapshot(documentSnapshot);
        debugPrint(
            'Notifcation send on token ${userModel.deviceToken} user name = ${userModel.firstName}');
        send(token: userModel.deviceToken, body: body, title: title);
      }
    } on Exception {
      // TODO
    }
    // }
  }

  Future<void> notificationRedireactionHandeler(
      {required NotificationBodyPayload notificationBodyPayload}) async {
    String? currentUserId =
        await sl.get<SharedPref>().get(SharedPref.userUID, defaultValue: null);
    if ((currentUserId ?? '').isNotEmpty) {
      if (notificationBodyPayload.notificationType ==
              NotificationType.addExpenseTrasactionByUser.name ||
          notificationBodyPayload.notificationType ==
              NotificationType.approveDispteExpenseMarkAsPersnalAction.name ||
          notificationBodyPayload.notificationType ==
              NotificationType.disputeExpeaseUpdateAgain.name ||
          notificationBodyPayload.notificationType ==
              NotificationType.transferAmount.name) {
        //Trasaction detail page redirection
        TransactionServices transactionServices = TransactionServices();
        final TrsactionAddExpenseModel? trsactionAddExpenseModel =
            await transactionServices.getSingleTransactionDetails(
                transaID: notificationBodyPayload.trascationId);

        // trsactionAddExpenseModel.userCommonModel = ,
        // trsactionAddExpenseModel.categoryRequestRespsModel,
        // trsactionAddExpenseModel.setUpPaymentModel,
        // trsactionAddExpenseModel.groupModel
        if (trsactionAddExpenseModel != null) {
          // ignore: use_build_context_synchronously
          kNavigatorKey.currentState?.context.present(TransactionDetailPage(
              transactionModel: trsactionAddExpenseModel));
        }
      } else if (notificationBodyPayload.notificationType ==
          NotificationType.joinRequestedUser.name) {
        // ignore: use_build_context_synchronously
        kNavigatorKey.currentState?.context
            .navigateTo(const ManageUserGroupScreen());
      }
    }
  }

  showDefault() {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('dbfood', 'EXPEANSE_TRACKER_CHANNEL',
            channelDescription: 'EXPEANSE_TRACKER_CHANNEL_DISCRIPTION',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true);

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    flutterLocalNotificationsPlugin.show(
        123,
        'event.notification?.title.toString()',
        '', //(event.notification?.body ?? "Body").toString(),
        notificationDetails,
        payload: 'jsonEncode(event.data)');
  }
}
