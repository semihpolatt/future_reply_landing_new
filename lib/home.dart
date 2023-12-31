import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import 'package:timer_count_down/timer_count_down.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientAnimationText(
                  duration: Duration(seconds: 2),
                  text: Text(
                    "FutureReply",
                    style:
                        TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                  colors: [
                    Colors.grey.shade500,
                    Colors.white,
                    //Colors.teal,
                  ],
                ),
                GradientAnimationText(
                  duration: Duration(seconds: 3),
                  text: Text(
                    "Extreme Fast Reply",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w100),
                  ),
                  colors: [
                    Colors.grey.shade500,
                    Colors.white,
                    //Colors.teal,
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (String heroTag in [
                      'images/whatsapp.png',
                      'images/x.png',
                      'images/gmail.png',
                      /* 'images/linkedin.png',
                      'images/imessage.png',
                      'images/slack.png', */
                    ])
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                  QueryPage(
                                    heroTag: heroTag,
                                  ),
                                  // curve: Curves.ease,
                                  transition: Transition.circularReveal,
                                  duration: Duration(seconds: 2));
                              /*    Get.toNamed('/queryPage',
                                  arguments: {'heroTag': heroTag}); */
                            },
                            child: Hero(
                              tag: heroTag,
                              child: badges.Badge(
                                badgeContent: Countdown(
                                  seconds: 40,
                                  build: (BuildContext context, double time) =>
                                      Text(
                                    (time * 10).toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  interval: Duration(milliseconds: 100),
                                  onFinished: () {
                                    print('Timer is done!');
                                  },
                                ),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(heroTag))),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (String heroTag in [
                      /* 'images/whatsapp.png',
                      'images/x.png',
                      'images/gmail.png', */
                      'images/linkedin.png',
                      'images/imessage.png',
                      'images/slack.png',
                    ])
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                  QueryPage(
                                    heroTag: heroTag,
                                  ),
                                  transition: Transition.circularReveal,
                                  duration: Duration(seconds: 2));
                            },
                            child: Hero(
                              tag: heroTag,
                              child: badges.Badge(
                                badgeContent: Countdown(
                                  seconds: 40,
                                  build: (BuildContext context, double time) =>
                                      Text(
                                    (time * 10).toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  interval: Duration(milliseconds: 100),
                                  onFinished: () {
                                    print('Timer is done!');
                                  },
                                ),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(heroTag))),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
