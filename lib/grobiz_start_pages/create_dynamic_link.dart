import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_extend/share_extend.dart';
import 'package:share_plus/share_plus.dart';


class ShareAppLink{

  static Future<Uri> createDynamicLink (String admin_auto_id) async {

    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://efunhub.page.link',
      link: Uri.parse('https://play.google.com/store/apps/details?id=com.poultryapp.poultry_a2z&admin_auto_id=$admin_auto_id'),
      androidParameters: AndroidParameters(
        packageName: 'com.poultryapp.poultry_a2z',
        minimumVersion: 45,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.geobull.geobullEcommerce',
        minimumVersion: '1',
        appStoreId: '6443653148',
      ),
    );

    final ShortDynamicLink dynamicUrl =
    await dynamicLinks.buildShortLink(parameters);

    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  static Future<Uri> createDynamicLinkProduct (String product_auto_id, String admin_auto_id,) async {

    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://efunhub.page.link',
      link:
      Uri.parse('https://play.google.com/store/apps/details?id=com.poultryapp.poultry_a2z&product_auto_id=$product_auto_id&admin_auto_id=$admin_auto_id'),
      androidParameters: AndroidParameters(
        packageName: 'com.poultryapp.poultry_a2z',
        minimumVersion: 45,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.test.demo',
        minimumVersion: '1',
        appStoreId: '',
      ),
    );

    final ShortDynamicLink dynamicUrl =
    await dynamicLinks.buildShortLink(parameters);

    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  static shareApp(String appName, File app_logo, String admin_auto_id) async{

    print(appName);
    print(app_logo.path);
    String message='Download the '+appName+'\n';

    print('message: '+ message);

    var dynamicLink = await createDynamicLink(admin_auto_id);

    print('dynamic link: '+ dynamicLink.toString());

    //ShareExtend.share(app_logo.path, message+dynamicLink.toString());

    //Share.shareFiles([app_logo.path], text: dynamicLink.toString());

    Share.share(message+dynamicLink.toString(), );
  }
}