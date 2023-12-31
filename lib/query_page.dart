import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:badges/badges.dart' as badges;

class QueryPage extends StatelessWidget {
  final String? heroTag;
  QueryPage({super.key, this.heroTag = ''});

  final CharacterController characterController =
      Get.put(CharacterController());
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: Colors.black,
        child: SingleChildScrollView(
          child: SelectionArea(
            child: Column(
              children: [
                SizedBox(
                  height: h * .1,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Hero(
                    tag: heroTag!,
                    child: badges.Badge(
                      badgeContent: Countdown(
                        seconds: 40,
                        build: (BuildContext context, double time) => Text(
                          (time * 10).toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        interval: Duration(
                          milliseconds: 100,
                        ),
                        onFinished: () {
                          print('Timer is done!');
                        },
                      ),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(heroTag!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * .02,
                ),
                GlassContainer(
                  height: h * .2,
                  width: 400,
                  border: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: (value) {
                        characterController.query.value = value;
                      },
                      maxLines: null,
                      style: TextStyle(
                        /*   fontSize: 20,
                        fontWeight: FontWeight.normal, */
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        //  contentPadding: EdgeInsets.only(right: 30.0),

                        suffixIcon: IconButton(
                          onPressed: () {
                            characterController.query1();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        labelText: 'Paste Here',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.blueGrey,
                          letterSpacing: 0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * .01,
                ),
                InkWell(
                  onTap: () {
                    characterController.isPromptOpen.value =
                        !characterController.isPromptOpen.value;
                  },
                  child: Text(
                    'Prompts(Optinial)',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                Obx(() {
                  if (characterController.isPromptOpen.value == true) {
                    return Container(
                      width: 400,
                      child: Column(
                        children: [
                          SizedBox(
                            height: h * .02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              onChanged: (value) {
                                // characterController.query.value = value;
                              },
                              maxLines: null,
                              style: TextStyle(
                                /*   fontSize: 20,
                                                fontWeight: FontWeight.normal, */
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                              decoration: InputDecoration(
                                //  contentPadding: EdgeInsets.only(right: 30.0),

                                labelText: 'Write Your Prompts Here',
                                labelStyle: TextStyle(
                                  // fontSize: 20,
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
                    );
                  } else {
                    return Container();
                  }
                }),
                SizedBox(
                  height: h * .02,
                ),
                // if (characterController.answer.value != '')
                Container(
                  width: 400,
                  child: Obx(() {
                    if (characterController.query.value != '') {
                      return Bubble(
                        radius: Radius.circular(10),
                        margin: BubbleEdges.only(top: 10, left: 10, right: 100),
                        padding: BubbleEdges.all(10),
                        nip: BubbleNip.leftBottom,
                        color: Color(0xffE9E9EB),
                        child: Text(
                          characterController.query.value,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
                Container(
                  width: 400,
                  child: Obx(() {
                    if (characterController.answer.value != '') {
                      return Bubble(
                        radius: Radius.circular(10),
                        margin: BubbleEdges.only(top: 10, left: 100, right: 10),
                        padding: BubbleEdges.all(10),
                        nip: BubbleNip.rightBottom,
                        color: Color(0xff007AFE),
                        child: Column(
                          children: [
                            Text(
                              characterController.answer.value,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
                SizedBox(
                  height: h * .1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CharacterController extends GetxController {
  RxString answer = ''.obs;
  RxString query = ''.obs;
  RxBool isPromptOpen = false.obs;

  final gemini = Gemini.instance;

  query1() {
    answer.value = '';

    gemini
        .streamGenerateContent(
            "Write a reply tweet, (sentence count is tweet's sentence count) to this tweet: " +
                query.value)
        .listen((value) {
      // print(value.output);
      for (Parts i in value.content!.parts!) {
        answer.value = answer.value + i.text!;
        answer.refresh();
      }
    });
  }
}
