import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:prochat/features/home/home_screen.dart';

class SignInController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Error',
          'No user found for that email',
          snackPosition: SnackPosition.BOTTOM,
          colorText: CupertinoColors.white,
          backgroundColor: CupertinoColors.systemRed,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Error',
          'Wrong password provided for that user',
          snackPosition: SnackPosition.BOTTOM,
          colorText: CupertinoColors.white,
          backgroundColor: CupertinoColors.systemRed,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Error',
          'The email address is badly formatted',
          snackPosition: SnackPosition.BOTTOM,
          colorText: CupertinoColors.white,
          backgroundColor: CupertinoColors.systemRed,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred. Please try again later',
        snackPosition: SnackPosition.BOTTOM,
        colorText: CupertinoColors.white,
        backgroundColor: CupertinoColors.systemRed,
      );
    }

    if (userCredential != null) {
      // Get.snackbar(
      //   'Success',
      //   'Sign in successful',
      //   snackPosition: SnackPosition.BOTTOM,
      //   colorText: CupertinoColors.white,
      //   backgroundColor: CupertinoColors.systemGreen,
      // );
      Get.offAll(() => const HomeScreen());
    }
  }
}
