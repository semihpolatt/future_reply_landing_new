import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';
import 'package:future_reply_landing_new/widgets/chat_input_area.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CharacterController characterController = Get.put(CharacterController());
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              if (w >= 500)
                GradientAnimationText(
                  duration: const Duration(seconds: 2),
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
                )
              else
                Text(
                  "FutureReply",
                  style: TextStyle(
                      fontSize: w >= 500 ? 80.0 : 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              if (w >= 500)
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
                )
              else
                Text(
                  "Extreme Fast Reply",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey),
                ),
              const SizedBox(
                height: 50,
              ),
              // Chat input area - now using the dedicated widget
              const ChatInputArea(),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
