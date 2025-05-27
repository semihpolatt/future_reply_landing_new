import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import '../query_page.dart';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'typing_indicator.dart';

class ChatInputArea extends StatefulWidget {
  const ChatInputArea({super.key});

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  late TextEditingController _queryController;
  late TextEditingController _promptController;
  late FocusNode _queryFocusNode;
  late FocusNode _promptFocusNode;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    _promptController = TextEditingController();
    _queryFocusNode = FocusNode();
    _promptFocusNode = FocusNode();

    // Add listeners to sync controllers with GetX reactive variables
    _queryController.addListener(() {
      final CharacterController characterController =
          Get.find<CharacterController>();
      if (_queryController.text != characterController.query.value) {
        characterController.query.value = _queryController.text;
      }
    });

    _promptController.addListener(() {
      final CharacterController characterController =
          Get.find<CharacterController>();
      if (_promptController.text != characterController.prompt.value) {
        characterController.prompt.value = _promptController.text;
      }
    });

    // Listen to answer changes to clear query field when response is received
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final CharacterController characterController =
          Get.find<CharacterController>();
      ever(characterController.answer, (String answer) {
        if (answer.isNotEmpty && !characterController.isLoading.value) {
          // Clear the query field when answer is received
          _queryController.clear();
          characterController.query.value = '';
          // Ensure focus is removed
          _clearAllFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _promptController.dispose();
    _queryFocusNode.dispose();
    _promptFocusNode.dispose();
    super.dispose();
  }

  // Helper method to remove focus from all text fields
  void _clearAllFocus() {
    _queryFocusNode.unfocus();
    _promptFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

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

        // Chat bubbles - using Container with fixed height instead of Flexible
        Container(
          height: w > 500 ? 400 : 300, // Responsive yükseklik
          child: _buildChatBubbles(w, characterController, isMobileSafari),
        ),
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
            controller: _queryController,
            focusNode: _queryFocusNode,
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
                      // Remove focus from all text fields before sending
                      _clearAllFocus();
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
            controller: _queryController,
            focusNode: _queryFocusNode,
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
                      // Remove focus from all text fields before sending
                      _clearAllFocus();
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
                        controller: _promptController,
                        focusNode: _promptFocusNode,
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // User query bubble
          _buildUserQueryBubble(w, controller, isMobileSafari),

          // Loading indicator (only show when loading and query is not empty)
          Obx(() {
            if (controller.isLoading.value &&
                controller.query.value.isNotEmpty) {
              if (w > 500) {
                return SizedBox(
                  width: 400,
                  child: Bubble(
                    radius: const Radius.circular(10),
                    margin:
                        const BubbleEdges.only(top: 10, left: 100, right: 10),
                    padding: const BubbleEdges.all(15),
                    nip: BubbleNip.rightBottom,
                    color: const Color(0xff007AFE),
                    child: const TypingIndicator(),
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(
                    bottom: isMobileSafari ? 15 : 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xff007AFE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const TypingIndicator(),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Container();
            }
          }),

          // AI answer bubble
          _buildAnswerBubble(w, controller, isMobileSafari),
        ],
      ),
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 200, // Maksimum yükseklik sınırı
              ),
              child: SingleChildScrollView(
                child: Text(
                  controller.query.value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
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
                constraints: const BoxConstraints(
                  maxHeight: 200, // Maksimum yükseklik sınırı
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE9E9EB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    controller.query.value,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black),
                  ),
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

      // Automatically copy the answer when bubble appears
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.answer.value.isNotEmpty && !controller.isLoading.value) {
          _copyToClipboard(controller.answer.value);
        }
      });

      if (w > 500) {
        return SizedBox(
          width: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Üstten hizala
            children: [
              // Copy icon on the left - sabit pozisyon
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _copyToClipboard(controller.answer.value);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              // Bubble
              Expanded(
                child: Bubble(
                  radius: const Radius.circular(10),
                  margin: const BubbleEdges.only(top: 10, left: 5, right: 10),
                  padding: const BubbleEdges.all(10),
                  nip: BubbleNip.rightBottom,
                  color: const Color(0xff007AFE),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300, // Maksimum yükseklik sınırı
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        controller.answer.value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
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
              crossAxisAlignment: CrossAxisAlignment.start, // Üstten hizala
              children: [
                // Copy icon on the left - sabit pozisyon
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        _copyToClipboard(controller.answer.value);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                // Bubble
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 300, // Maksimum yükseklik sınırı
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff007AFE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        controller.answer.value,
                        style: const TextStyle(color: Colors.white),
                      ),
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

      // Show small notification
      Get.snackbar(
        '',
        'Message copied',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        borderRadius: 8,
        maxWidth: 200,
        titleText: const SizedBox.shrink(), // Hide title
        messageText: const Text(
          'Message copied',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        animationDuration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      // Fallback for web browsers
      try {
        html.window.navigator.clipboard?.writeText(text);

        // Show small notification for web fallback too
        Get.snackbar(
          '',
          'Message copied',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          borderRadius: 8,
          maxWidth: 200,
          titleText: const SizedBox.shrink(), // Hide title
          messageText: const Text(
            'Message copied',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          animationDuration: const Duration(milliseconds: 300),
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

      // Show small notification for fallback method too
      Get.snackbar(
        '',
        'Message copied',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        borderRadius: 8,
        maxWidth: 200,
        titleText: const SizedBox.shrink(), // Hide title
        messageText: const Text(
          'Message copied',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        animationDuration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print('Kopyalama başarısız oldu');
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
            // Update both controller and text field
            controller.query.value = text;
            _queryController.text = text;
            // Remove focus from text field
            _clearAllFocus();
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
          // Update both controller and text field
          controller.query.value = data.text!;
          _queryController.text = data.text!;
          // Remove focus from text field
          _clearAllFocus();
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
                // Update both controller and text field
                controller.query.value = pasteController.text;
                _queryController.text = pasteController.text;
                Get.back();
                // Remove focus from text field
                _clearAllFocus();
                // Automatically trigger the query after pasting
                await Future.delayed(const Duration(milliseconds: 500));
                controller.query1();
              } else {
                // Boş text durumunda sadece dialog'u kapat
                Get.back();
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
