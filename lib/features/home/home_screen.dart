import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prochat/features/authentication/signup/signup_screen.dart';
import 'package:prochat/features/chatting/chat_screen.dart';
import 'package:prochat/features/home/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //show a dialog and let user enter the email of the person they want to chat with

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Enter the email',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  Obx(() {
                    return TextButton(
                      onPressed: () {
                        if (homeController.emailExists.value != true) {
                          return;
                        }

                        final userId = homeController.userId.value;

                        if (userId.isEmpty) {
                          Get.snackbar('Error', 'User ID is empty');
                          return;
                        }

                        Get.back();

                        Get.to(
                          () => ChatScreen(
                            userId: userId,
                            userEmail: homeController.userEmail.value,
                            userName: homeController.userName.value,
                          ),
                        );
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          color: homeController.emailExists.value
                              ? Colors.purple
                              : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ],
                // contentPadding: EdgeInsets.all(40),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      return TextFormField(
                        controller: homeController.emailController,
                        onChanged: (value) async {
                          await homeController.checkEmail();
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffix: homeController.emailExists.value
                              ? Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.cancel_outlined, color: Colors.red),
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.message_outlined),
      ),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(SignupScreen());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text('Welcome to ProChat'),
      ),
    );
  }
}
