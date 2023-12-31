import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: AssetImage(heroTag))),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
