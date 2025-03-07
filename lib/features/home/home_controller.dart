import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool emailExists = false.obs;

  final TextEditingController emailController = TextEditingController();

  Future<void> checkEmail() async {
    final String email = emailController.text;

    log('Checking email: $email', name: 'Email Check');

    final response = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (response.docs.isNotEmpty) {
      log('Email exists', name: 'Email Check');
      emailExists.value = true;
    } else {
      log('Email does not exist', name: 'Email Check');
      emailExists.value = false;
    }
  }
}
