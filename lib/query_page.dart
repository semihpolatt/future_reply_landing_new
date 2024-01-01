import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

class QueryPage extends StatelessWidget {
  final String? heroTag;

  const QueryPage({super.key, this.heroTag = ''});

  @override
  Widget build(BuildContext context) {
    CharacterController characterController = Get.put(CharacterController());
    TextEditingController textEditingController = TextEditingController();
    // CharacterController characterController = Get.put(CharacterController());
    //CharacterController characterController = Get.find<CharacterController>();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SelectionArea(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Hero(
                  tag: heroTag!,
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
              const SizedBox(
                height: 10,
              ),
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
                TextField(
                  onChanged: (value) {
                    characterController.query = value.obs;
                  },
                  maxLines: null,
                  style: const TextStyle(
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
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  characterController.isPromptOpen.value =
                      !characterController.isPromptOpen.value;
                },
                child: Text(
                  'Prompts(Optinial)${characterController.query.value}',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              Obx(() {
                if (characterController.isPromptOpen.value == true) {
                  return SizedBox(
                    width: 400,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            onChanged: (value) {
                              // characterController.query.value = value;
                              characterController.prompt = value.obs;
                            },
                            maxLines: null,
                            style: const TextStyle(
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
              const SizedBox(
                height: 10,
              ),
              // if (characterController.answer.value != '')
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
              if (w < 500)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 400,
                    child: Obx(() {
                      if (characterController.answer.value != '') {
                        return Text(
                          characterController.answer.value,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharacterController extends GetxController {
  RxString answer = ''.obs;
  RxString query = ''.obs;
  RxString prompt = ''.obs;
  RxBool isPromptOpen = false.obs;

  final gemini = Gemini.instance;

  query1() {
    answer.value = '';

    gemini
        .streamGenerateContent(
            "${prompt.value} ,Write a reply tweet, (sentence count is tweet's sentence count) to this tweet: ${query.value}")
        .listen((value) {
      // print(value.output);
      for (Parts i in value.content!.parts!) {
        answer.value = answer.value + i.text!;
        answer.refresh();
      }
    });
  }
}
