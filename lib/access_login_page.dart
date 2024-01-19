import 'package:flutter/material.dart';
import 'package:future_reply_landing_new/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'query_page.dart';

class AccessLoginPage extends StatelessWidget {
  const AccessLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    CharacterController characterController = Get.put(CharacterController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
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
                          characterController.accessCode.value = value;
                          //characterController.prompt = value.obs;
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
                              if (characterController.accessCode.value ==
                                      '5555' ||
                                  characterController.accessCode.value ==
                                      '68174113') {
                                GetStorage().write('accessCode', '68174113');
                                Get.offAll(HomePage());
                              } else {
                                Get.defaultDialog(
                                  title: "Access Code Is Wrong!",
                                  middleText: "",
                                  backgroundColor: Colors.green,
                                  titleStyle: TextStyle(color: Colors.white),
                                  middleTextStyle:
                                      TextStyle(color: Colors.white),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.login_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),

                          labelText: 'Please Enter Your Access Code Here',
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
