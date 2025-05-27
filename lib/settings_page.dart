import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'create_character_page.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onSave;

  const SettingsPage({
    super.key,
    required this.onSave,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedCharacterIndex = 0;
  bool useCharacter = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Load previously selected character and toggle state
    useCharacter = storage.read('use_character') ?? false;
    final savedCharacter = storage.read('selected_character');
    if (savedCharacter != null) {
      final allChars = allCharacters;
      for (int i = 0; i < allChars.length; i++) {
        if (allChars[i]['emoji'] == savedCharacter['emoji'] &&
            allChars[i]['title'] == savedCharacter['title'] &&
            allChars[i]['description'] == savedCharacter['description']) {
          selectedCharacterIndex = i;
          break;
        }
      }
    }
  }

  final List<Map<String, String>> defaultCharacters = [
    {
      'emoji': '💼',
      'title': 'LinkedIn Warrior',
      'description': 'professional, networker, ambitious'
    },
    {
      'emoji': '💕',
      'title': 'Dating Guru',
      'description': 'charming, confident, romantic'
    },
    {
      'emoji': '👯‍♀️',
      'title': 'Best Friend',
      'description': 'supportive, loyal, fun'
    },
    {
      'emoji': '🤝',
      'title': 'Sales Negotiator',
      'description': 'persuasive, tough, deal-maker'
    },
    {
      'emoji': '☕',
      'title': 'Coffee Addict',
      'description': 'energetic, workaholic, caffeine-powered'
    },
    {
      'emoji': '🎮',
      'title': 'Gaming Buddy',
      'description': 'competitive, strategic, night owl'
    },
    {
      'emoji': '📱',
      'title': 'Social Media Expert',
      'description': 'trendy, influencer, digital native'
    },
    {
      'emoji': '🍕',
      'title': 'Foodie Friend',
      'description': 'adventurous, social, always hungry'
    },
  ];

  List<Map<String, String>> get allCharacters {
    List<dynamic> customCharacters = storage.read('custom_characters') ?? [];
    List<Map<String, String>> characters = List.from(defaultCharacters);

    for (var custom in customCharacters) {
      characters.add({
        'emoji': custom['emoji'].toString(),
        'title': custom['title'].toString(),
        'description': custom['description'].toString(),
      });
    }

    return characters;
  }

  void deleteCharacter(int index) {
    final characters = allCharacters;
    final character = characters[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Character',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${character['title']}"?',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // Check if it's a custom character (not in default characters)
                if (index >= defaultCharacters.length) {
                  // It's a custom character, remove it from storage
                  List<dynamic> customCharacters =
                      storage.read('custom_characters') ?? [];
                  int customIndex = index - defaultCharacters.length;
                  customCharacters.removeAt(customIndex);
                  storage.write('custom_characters', customCharacters);

                  setState(() {
                    // Adjust selected index if necessary
                    if (selectedCharacterIndex == index) {
                      selectedCharacterIndex = 0; // Reset to first character
                    } else if (selectedCharacterIndex > index) {
                      selectedCharacterIndex--; // Adjust index
                    }
                  });

                  Get.snackbar(
                    'Success',
                    'Character deleted successfully!',
                    backgroundColor: Colors.green.withOpacity(0.8),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                } else {
                  // It's a default character, can't delete
                  Get.snackbar(
                    'Error',
                    'Default characters cannot be deleted',
                    backgroundColor: Colors.red.withOpacity(0.8),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToCreateCharacter() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateCharacterPage()),
    );

    if (result != null && result['success'] == true) {
      setState(() {
        // Refresh the character list and select the newly created character
        // The new character will be at the end of the custom characters list
        final allChars = allCharacters;
        selectedCharacterIndex = allChars.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final characters = allCharacters;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Character Settings Section
                const Text(
                  'Character Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[800]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use Character Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Use Character',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: useCharacter,
                            onChanged: (value) {
                              setState(() {
                                useCharacter = value;
                                storage.write('use_character', value);
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.white.withOpacity(0.3),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.withOpacity(0.3),
                          ),
                        ],
                      ),
                      if (useCharacter) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Character Personality',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Character Slider
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                characters.length + 1, // +1 for "Create New"
                            itemBuilder: (context, index) {
                              if (index == characters.length) {
                                // Create New Character Card
                                return GestureDetector(
                                  onTap: navigateToCreateCharacter,
                                  child: Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[700]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Create New',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // Character Card
                              final character = characters[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCharacterIndex = index;
                                  });
                                },
                                onLongPress: () {
                                  deleteCharacter(index);
                                },
                                child: Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: selectedCharacterIndex == index
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.grey[850],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedCharacterIndex == index
                                          ? Colors.white.withOpacity(0.3)
                                          : Colors.grey[700]!,
                                      width: selectedCharacterIndex == index
                                          ? 2
                                          : 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        character['emoji']!,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        character['title']!,
                                        style: TextStyle(
                                          color: selectedCharacterIndex == index
                                              ? Colors.white
                                              : Colors.grey[300],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          character['description']!,
                                          style: TextStyle(
                                            color:
                                                selectedCharacterIndex == index
                                                    ? Colors.grey[400]
                                                    : Colors.grey[500],
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Save selected character and toggle state to storage
                      storage.write('use_character', useCharacter);
                      if (useCharacter &&
                          selectedCharacterIndex < allCharacters.length) {
                        storage.write('selected_character',
                            allCharacters[selectedCharacterIndex]);
                      } else if (!useCharacter) {
                        // Clear selected character when toggle is off
                        storage.remove('selected_character');
                      }

                      // Show success message
                      Get.snackbar(
                        'Success',
                        'Settings saved successfully!',
                        backgroundColor: Colors.green.withOpacity(0.8),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );

                      widget.onSave();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
