import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:future_reply_landing_new/query_page.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

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
              // Chat input area
              if (w > 500)
                GlassContainer(
                  height: 150,
                  width: 400,
                  border: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: (value) {
                        characterController.query = value.obs;
                      },
                      maxLines: null,
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            characterController.query1();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        labelText: 'Paste Here',
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.blueGrey,
                          letterSpacing: 0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      characterController.query = value.obs;
                    },
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          characterController.query1();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                      labelText: 'Paste Here',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey,
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  characterController.isPromptOpen.value =
                      !characterController.isPromptOpen.value;
                },
                child: const Text(
                  'Prompts(Optional)',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Obx(() {
                if (characterController.isPromptOpen.value == true) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: w > 500 ? 400 : w - 40,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                onChanged: (value) {
                                  characterController.prompt = value.obs;
                                },
                                maxLines: null,
                                style: const TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Write Your Prompts Here',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[50],
                                    letterSpacing: 0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
              const SizedBox(
                height: 20,
              ),
              // Chat bubbles area
              if (w > 500)
                SizedBox(
                  width: 400,
                  child: Obx(() {
                    if (characterController.query.value != '') {
                      return Bubble(
                        radius: const Radius.circular(10),
                        margin: const BubbleEdges.only(
                            top: 10, left: 10, right: 100),
                        padding: const BubbleEdges.all(10),
                        nip: BubbleNip.leftBottom,
                        color: const Color(0xffE9E9EB),
                        child: Text(
                          characterController.query.value,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
              if (w > 500)
                SizedBox(
                  width: 400,
                  child: Obx(() {
                    if (characterController.answer.value != '') {
                      return Bubble(
                        radius: const Radius.circular(10),
                        margin: const BubbleEdges.only(
                            top: 10, left: 100, right: 10),
                        padding: const BubbleEdges.all(10),
                        nip: BubbleNip.rightBottom,
                        color: const Color(0xff007AFE),
                        child: Column(
                          children: [
                            Text(
                              characterController.answer.value,
                              textAlign: TextAlign.right,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
              if (w <= 500)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: w - 40,
                    child: Obx(() {
                      if (characterController.query.value != '') {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xffE9E9EB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            characterController.query.value,
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ),
              if (w <= 500)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: w - 40,
                    child: Obx(() {
                      if (characterController.answer.value != '') {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xff007AFE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            characterController.answer.value,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ),
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
