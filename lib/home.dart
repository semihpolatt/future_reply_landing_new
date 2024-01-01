import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CharacterController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          GradientAnimationText(
            duration: const Duration(seconds: 2),
            text: const Text(
              "FutureReply",
              style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w100),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (String heroTag in [
                // 'images/whatsapp.png',
                'images/x.png',
                'images/gmail.png',
                'images/linkedin.png',
                'images/imessage.png',
                'images/slack.png',
              ])
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    QueryPage(
                              heroTag: heroTag,
                            ),
                            transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            transitionDuration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Hero(
                        tag: heroTag,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: AssetImage(heroTag))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              openInWindow('https://forms.gle/GkxFAFWY7RjE1iNq8', '_blank');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey,
              ),
              child: Text(
                'Join the Waitlist!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void openInWindow(String uri, String name) {
  html.window.open(uri, name);
}
