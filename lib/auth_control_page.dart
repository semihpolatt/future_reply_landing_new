import 'package:flutter/material.dart';
import 'package:future_reply_landing_new/access_login_page.dart';
import 'package:future_reply_landing_new/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthControlPage extends StatefulWidget {
  @override
  _AuthControlPageState createState() => _AuthControlPageState();
}

class _AuthControlPageState extends State<AuthControlPage> {
  final box = GetStorage();
  RxBool log = false.obs;
  void initState() {
    super.initState();
    log.value = isloggedIn();
    if (log == true) {
      Future.delayed(Duration.zero, () {
        //TODO: anasayfaya yolla
        Get.offAll(HomePage());
      });
    } else {
      Future.delayed(Duration.zero, () {
        Get.offAll(AccessLoginPage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = Get.width;
    return Container();
  }

  isloggedIn() {
    if (box.read('accessCode') != null) {
      return true;
      //Get.offAll(SilverAppBarWithTabBarScreen());
    } else {
      return false;
      //Get.offAll(Login1Page());
    }
  }
}
