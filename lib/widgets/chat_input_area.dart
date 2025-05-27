import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import '../query_page.dart';
import 'dart:html' as html;
import 'package:flutter/services.dart';

class ChatInputArea extends StatelessWidget {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterController characterController =
        Get.find<CharacterController>();
    final double w = MediaQuery.of(context).size.width;

    // Check if we're on mobile Safari
    bool isMobileSafari = _isMobileSafari();

    return Column(
      children: [
        // Chat input field
        _buildInputField(w, characterController, isMobileSafari),

        const SizedBox(height: 10),

        // Prompts toggle
        _buildPromptsToggle(characterController),

        // Prompts input field (conditional)
        _buildPromptsField(w, characterController, isMobileSafari),

        const SizedBox(height: 20),

        // Chat bubbles
        _buildChatBubbles(w, characterController, isMobileSafari),
      ],
    );
  }

  Widget _buildInputField(
      double w, CharacterController controller, bool isMobileSafari) {
    // Adjust container height for mobile Safari
    double containerHeight = isMobileSafari ? 120 : 150;

    if (w > 500) {
      return GlassContainer(
        height: containerHeight,
        width: 400,
        border: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            onChanged: (value) {
              controller.query.value = value;
            },
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.query1();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _pasteFromClipboard(controller);
                    },
                    icon: const Icon(
                      Icons.paste,
                      color: Colors.white,
                      size: 40,
                    ),
                    tooltip: 'Paste from Clipboard',
                  ),
                ],
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
      return Container(
        margin: EdgeInsets.only(
          bottom: isMobileSafari ? 10 : 0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (value) {
              controller.query.value = value;
            },
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.query1();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _pasteFromClipboard(controller);
                    },
                    icon: const Icon(
                      Icons.paste,
                      color: Colors.white,
                      size: 40,
                    ),
                    tooltip: 'Paste from Clipboard',
                  ),
                ],
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

  Widget _buildPromptsField(
      double w, CharacterController controller, bool isMobileSafari) {
    return Obx(() {
      if (controller.isPromptOpen.value) {
        return Container(
          margin: EdgeInsets.only(
            bottom: isMobileSafari ? 15 : 0,
          ),
          child: Row(
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
                          controller.prompt.value = value;
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
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget _buildChatBubbles(
      double w, CharacterController controller, bool isMobileSafari) {
    return Column(
      children: [
        // User query bubble
        _buildUserQueryBubble(w, controller, isMobileSafari),

        // AI answer bubble
        _buildAnswerBubble(w, controller, isMobileSafari),
      ],
    );
  }

  Widget _buildUserQueryBubble(
      double w, CharacterController controller, bool isMobileSafari) {
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
        return Container(
          margin: EdgeInsets.only(
            bottom: isMobileSafari ? 15 : 10,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: w - 40,
              child: Container(
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
          ),
        );
      }
    });
  }

  Widget _buildAnswerBubble(
      double w, CharacterController controller, bool isMobileSafari) {
    return Obx(() {
      if (controller.answer.value.isEmpty) return Container();

      if (w > 500) {
        return SizedBox(
          width: 400,
          child: Row(
            children: [
              // Copy icon on the left
              IconButton(
                onPressed: () {
                  _copyToClipboard(controller.answer.value);
                },
                icon: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 40,
                ),
                tooltip: 'Copy the Response',
              ),
              // Bubble
              Expanded(
                child: Bubble(
                  radius: const Radius.circular(10),
                  margin: const BubbleEdges.only(top: 10, left: 10, right: 10),
                  padding: const BubbleEdges.all(10),
                  nip: BubbleNip.rightBottom,
                  color: const Color(0xff007AFE),
                  child: Text(
                    controller.answer.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(
            bottom: isMobileSafari ? 20 : 10,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Copy icon on the left
                IconButton(
                  onPressed: () {
                    _copyToClipboard(controller.answer.value);
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 20,
                  ),
                  tooltip: 'Cevabı Kopyala',
                ),
                // Bubble
                Expanded(
                  child: Container(
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
              ],
            ),
          ),
        );
      }
    });
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

  // Helper method to copy text to clipboard
  void _copyToClipboard(String text) async {
    try {
      // Try using Flutter's clipboard first
      await Clipboard.setData(ClipboardData(text: text));

      // Show success message
      Get.snackbar(
        'Success',
        'Message copied!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Fallback for web browsers
      try {
        html.window.navigator.clipboard?.writeText(text);
        Get.snackbar(
          'Başarılı',
          'Mesaj kopyalandı!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (webError) {
        // Final fallback for older browsers
        _fallbackCopyToClipboard(text);
      }
    }
  }

  // Fallback method for older browsers
  void _fallbackCopyToClipboard(String text) {
    try {
      final textArea = html.TextAreaElement();
      textArea.value = text;
      html.document.body?.append(textArea);
      textArea.select();
      html.document.execCommand('copy');
      textArea.remove();

      Get.snackbar(
        'Başarılı',
        'Mesaj kopyalandı!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kopyalama başarısız oldu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Helper method to paste text from clipboard
  void _pasteFromClipboard(CharacterController controller) async {
    try {
      // For web, try the modern clipboard API first
      if (html.window.navigator.clipboard != null) {
        try {
          String text = await html.window.navigator.clipboard!.readText();
          if (text.isNotEmpty) {
            controller.query.value = text;
            Get.snackbar(
              'Success',
              'Text pasted and processing...',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue.withOpacity(0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            // Automatically trigger the query after pasting
            await Future.delayed(const Duration(milliseconds: 500));
            controller.query1();
            return;
          }
        } catch (e) {
          print('Clipboard API error: $e');
        }
      }

      // Fallback: Try Flutter's clipboard
      try {
        ClipboardData? data = await Clipboard.getData('text/plain');
        if (data != null && data.text != null && data.text!.isNotEmpty) {
          controller.query.value = data.text!;
          Get.snackbar(
            'Success',
            'Text pasted and processing...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          // Automatically trigger the query after pasting
          await Future.delayed(const Duration(milliseconds: 500));
          controller.query1();
          return;
        }
      } catch (e) {
        print('Flutter clipboard error: $e');
      }

      // If all else fails, show manual paste dialog
      _showManualPasteDialog(controller);
    } catch (e) {
      print('General paste error: $e');
      _showManualPasteDialog(controller);
    }
  }

  // Show manual paste dialog
  void _showManualPasteDialog(CharacterController controller) {
    TextEditingController pasteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Paste Content',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please paste your content below (Ctrl+V / Cmd+V):',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pasteController,
              autofocus: true,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Paste here and click Done...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              if (pasteController.text.isNotEmpty) {
                controller.query.value = pasteController.text;
                Get.back();
                Get.snackbar(
                  'Success',
                  'Text pasted and processing...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                // Automatically trigger the query after pasting
                await Future.delayed(const Duration(milliseconds: 500));
                controller.query1();
              } else {
                Get.snackbar(
                  'Error',
                  'Please paste some text first',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              }
            },
            child: const Text('Done', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // Fallback method for older browsers and iOS Safari
  void _fallbackPasteFromClipboard(CharacterController controller) {
    _showManualPasteDialog(controller);
  }
}
