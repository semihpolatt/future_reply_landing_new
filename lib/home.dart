import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';
import 'package:future_reply_landing_new/widgets/chat_input_area.dart';
import 'package:future_reply_landing_new/settings_page.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CharacterController characterController = Get.put(CharacterController());
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    // Check if we're on mobile Safari
    bool isMobileSafari = _isMobileSafari();

    // Calculate safe bottom padding for mobile Safari
    double bottomPadding = isMobileSafari ? 80.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.grey,
                size: 28,
              ),
              onPressed: () {
                _openSettingsPage(context);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false, // We'll handle bottom padding manually for Safari
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SelectionArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: h -
                    (isMobileSafari
                        ? 0
                        : MediaQuery.of(context).padding.bottom),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isMobileSafari ? 80 : 100,
                  ),
                  if (w >= 500)
                    GradientAnimationText(
                      duration: const Duration(seconds: 2),
                      text: Text(
                        "FutureReply",
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w100),
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
                  SizedBox(
                    height: bottomPadding,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to detect mobile Safari
  bool _isMobileSafari() {
    try {
      final userAgent = html.window.navigator.userAgent;
      return userAgent.contains('Safari') &&
          userAgent.contains('Mobile') &&
          !userAgent.contains('Chrome') &&
          !userAgent.contains('CriOS') &&
          !userAgent.contains('FxiOS');
    } catch (e) {
      return false;
    }
  }

  void _openSettingsPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(
          onSave: () {
            Navigator.of(context).pop();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
