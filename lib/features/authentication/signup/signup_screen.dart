import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prochat/features/authentication/signup/singup_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: signupController.formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text('Sign up to ProChat'),
              const SizedBox(height: 16),
              TextFormField(
                controller: signupController.nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: signupController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () {
                  return TextFormField(
                    controller: signupController.passwordController,
                    obscureText: !signupController.isPasswordVisible.value,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: () {
                          signupController.isPasswordVisible.value =
                              !signupController.isPasswordVisible.value;
                        },
                        icon: signupController.isPasswordVisible.value
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (signupController.formKey.currentState!.validate()) {
                    await signupController.signUp();
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
