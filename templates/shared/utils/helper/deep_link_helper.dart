// ignore: depend_on_referenced_packages

import 'package:expense_tracker/screens/profile/join_organisation_via_invite/join_organisation_via_invite_screen.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/common/config.dart';
import 'package:expense_tracker/utils/common/env.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DeepLinkURLCreate {
  DeepLinkURLCreate();
  // Community Home Dynamic Links
  Future<String> getInvitedCodeURL(
      int inviteCode, String msg, String iosUrl, String adroidUrl) async {
    // String frontUrl =
    //     (aGeneralBloc.getConfigurationsBaseStream.valueOrNull?.s3Link ?? '') +
    //         '/';

    String dynamicLink = await FirebaseDeepLink.instance.createDynmicLink(
        inviteCode, msg,
        adroidUrl: adroidUrl, iosUrl: iosUrl);
    return dynamicLink;
  }

  // Future<void> shareCode(int inviteCode, String msg,
  //     {required String iosUrl, required String adroidUrl}) async {
  //   String subject =
  //       await getInvitedCodeURL(inviteCode, msg, iosUrl, adroidUrl);
  //   debugPrint(subject);
  //   Share.share(subject);
  // }

  Future<void> shareCode(int inviteCode, String msg,
      {required String iosUrl, required String adroidUrl}) async {
    final String subject =
        await getInvitedCodeURL(inviteCode, msg, iosUrl, adroidUrl);
    debugPrint(subject);

    final String completeShareingContent =
        '$msg click on this link $subject.\nFor install the app you can click here ios : $iosUrl android : $adroidUrl';
    // print(completeShareingContent);
    Share.share(completeShareingContent);
  }
}

class FirebaseDeepLink {
  FirebaseDeepLink._privateConstructor();

  static final FirebaseDeepLink _instance =
      FirebaseDeepLink._privateConstructor();

  static FirebaseDeepLink get instance => _instance;

  void initDynamicLinks() async {
    //await Future.delayed(Duration(seconds: 2));
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      debugPrint('deepLink Dynamic >>> $deepLink');
      debugPrint('deepLink path Dynamic >>> ${deepLink.path}');
      if (deepLink.queryParameters.isNotEmpty) {
        //invitedCode
        int inviteCode =
            int.parse(deepLink.queryParameters['invitedCode'] ?? '0');
        if (inviteCode != 0) {
          if ((aGeneralBloc.currentUserId ?? '').isNotEmpty) {
            kNavigatorKey.currentContext?.navigateTo(
                JoinOrganisationViaInviteScreen(
                    inviteCode: inviteCode, isFromDeepLink: true));
          }
        }
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      debugPrint('deepLink onsuccess >>> $deepLink');
      debugPrint('deepLink path onsuccess >>> ${deepLink.path}');
      debugPrint(
          'deepLink path queryParameters onsuccess >>> ${deepLink.queryParameters}');
      if (deepLink.queryParameters.isNotEmpty) {
        //invitedCode
        int inviteCode =
            int.parse(deepLink.queryParameters['invitedCode'] ?? '0');
        if (inviteCode != 0) {
          if ((aGeneralBloc.currentUserId ?? '').isNotEmpty) {
            kNavigatorKey.currentContext?.navigateTo(
                JoinOrganisationViaInviteScreen(
                    inviteCode: inviteCode, isFromDeepLink: true));
          }
        }
      }
      // aGeneralBloc.updateDeepLinkUri(deepLink);
      // aGeneralBloc.updateIsOpenFromDeepLink(true);
    }).onError((error) {
      debugPrint(' deepLink onsuccess $error');
      debugPrint(error.message);
    });
  }

//expensetrackerlive.page.link
  Future<String> createDynmicLink(int inviteCode, String msg,
      {required String iosUrl, required String adroidUrl}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://${env.baseurl}',
      link: Uri.parse('https://${env.baseurl}/?invitedCode=$inviteCode'),
      androidParameters: AndroidParameters(
        packageName: 'com.indianic.expensetracker.enterprise',
        fallbackUrl: Uri.parse(adroidUrl),
        //minimumVersion: 125,
      ),
      iosParameters:
          IOSParameters(bundleId: env.iosPackage, fallbackUrl: Uri.parse(iosUrl)
              //minimumVersion: '1.0.1',
              // appStoreId: '376771144',
              ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: msg,
        // imageUrl: Uri.parse(videoThumbUrl ??
        //     "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
      ),
      // navigationInfoParameters: NavigationInfoParameters(),
      //dynamicLinkParametersOptions: DynamicLinkParametersOptions(),

      // googleAnalyticsParameters: GoogleAnalyticsParameters(
      //     campaign: 'example-promo',
      //     medium: 'social',
      //     source: 'orkut',
      // ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      // socialMetaTagParameters:  SocialMetaTagParameters(
      //   title: 'Example of a Dynamic Link',
      //   description: 'This link works whether app is installed or not!',
      // ),
    );

    //final Uri dynamicUrl = await parameters.buildUrl();
    Uri urlnew;
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    urlnew = shortLink.shortUrl;
    // final ShortDynamicLink shortLink = await parameters.buildShortLink();
    // final Uri shortUrl = shortLink.shortUrl;
    debugPrint(urlnew.toString());
    return urlnew.toString();

    // url = await dynamicLinks.buildLink(parameters);
  }
}
