import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prochat/features/home/home_screen.dart';

class SignupController extends GetxController {


  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUp() async {
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          'Error',
          'The password provided is too weak',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Error',
          'The account already exists with that email',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Error',
          'The email address is badly formatted',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else if (e.code == 'operation-not-allowed') {
        Get.snackbar(
          'Error',
          'Email & Password accounts are not enabled. Enable them in the Auth section of the Firebase console',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred. Please try again',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    if (userCredential != null) {
      await saveUser(
        userId: userCredential.user!.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      ).then((value) {
        Get.offAll(() =>  HomeScreen());
        // Get.snackbar(
        //   'Success',
        //   'User created successfully',
        //   snackPosition: SnackPosition.BOTTOM,
        //   colorText: Colors.white,
        //   backgroundColor: Colors.green,
        // );
      });
    }
  }

  Future<void> saveUser(
      {required String userId,
      required String name,
      required String email}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'userId': userId,
        'createdAt': Timestamp.now(),
      });
    } on Exception catch (e) {
      log(e.toString(), name: 'Save User');
      Get.snackbar(
        'Error',
        'An error occurred. Please try again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return Future.error(e);
    }
  }
}
