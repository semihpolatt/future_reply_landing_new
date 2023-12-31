import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import 'package:timer_count_down/timer_count_down.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  duration: const Duration(seconds: 2),
                  text: const Text(
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
                  duration: const Duration(seconds: 3),
                  text: const Text(
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
                const SizedBox(
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
                                  duration: const Duration(seconds: 2));
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  interval: const Duration(milliseconds: 100),
                                  onFinished: () {},
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
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                  ],
                ),
                const SizedBox(
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
                                  duration: const Duration(seconds: 2));
                            },
                            child: Hero(
                              tag: heroTag,
                              child: badges.Badge(
                                badgeContent: Countdown(
                                  seconds: 40,
                                  build: (BuildContext context, double time) =>
                                      Text(
                                    (time * 10).toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  interval: const Duration(milliseconds: 100),
                                  onFinished: () {},
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
                          const SizedBox(
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
