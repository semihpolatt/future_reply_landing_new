import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import '../query_page.dart';

class ChatInputArea extends StatelessWidget {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterController characterController =
        Get.find<CharacterController>();
    final double w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Chat input field
        _buildInputField(w, characterController),

        const SizedBox(height: 10),

        // Prompts toggle
        _buildPromptsToggle(characterController),

        // Prompts input field (conditional)
        _buildPromptsField(w, characterController),

        const SizedBox(height: 20),

        // Chat bubbles
        _buildChatBubbles(w, characterController),
      ],
    );
  }

  Widget _buildInputField(double w, CharacterController controller) {
    if (w > 500) {
      return GlassContainer(
        height: 150,
        width: 400,
        border: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            onChanged: (value) {
              controller.query = value.obs;
            },
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  controller.query1();
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
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          onChanged: (value) {
            controller.query = value.obs;
          },
          maxLines: null,
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                controller.query1();
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
      );
    }
  }

  Widget _buildPromptsToggle(CharacterController controller) {
    return InkWell(
      onTap: () {
        controller.isPromptOpen.value = !controller.isPromptOpen.value;
      },
      child: const Text(
        'Prompts(Optional)',
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildPromptsField(double w, CharacterController controller) {
    return Obx(() {
      if (controller.isPromptOpen.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: w > 500 ? 400 : w - 40,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: (value) {
                        controller.prompt = value.obs;
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
    });
  }

  Widget _buildChatBubbles(double w, CharacterController controller) {
    return Column(
      children: [
        // User query bubble
        _buildUserQueryBubble(w, controller),

        // AI answer bubble
        _buildAnswerBubble(w, controller),
      ],
    );
  }

  Widget _buildUserQueryBubble(double w, CharacterController controller) {
    return Obx(() {
      if (controller.query.value.isEmpty) return Container();

      if (w > 500) {
        return SizedBox(
          width: 400,
          child: Bubble(
            radius: const Radius.circular(10),
            margin: const BubbleEdges.only(top: 10, left: 10, right: 100),
            padding: const BubbleEdges.all(10),
            nip: BubbleNip.leftBottom,
            color: const Color(0xffE9E9EB),
            child: Text(
              controller.query.value,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: w - 40,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffE9E9EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.query.value,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildAnswerBubble(double w, CharacterController controller) {
    return Obx(() {
      if (controller.answer.value.isEmpty) return Container();

      if (w > 500) {
        return SizedBox(
          width: 400,
          child: Bubble(
            radius: const Radius.circular(10),
            margin: const BubbleEdges.only(top: 10, left: 100, right: 10),
            padding: const BubbleEdges.all(10),
            nip: BubbleNip.rightBottom,
            color: const Color(0xff007AFE),
            child: Text(
              controller.answer.value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: w - 40,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff007AFE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.answer.value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }
    });
  }
}
