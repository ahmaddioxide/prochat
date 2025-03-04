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
              const Text('Sign up to ProChat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  if (signupController.formKey.currentState!.validate()) {
                    signupController.isLoading.value = true;
                    await signupController.signUp();
                    signupController.isLoading.value = false;
                  }
                },
                child: Obx(() {
                  if (signupController.isLoading.value == true) {
                    return SizedBox(
                      height: 24,
                      width: 24,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }
                  return Text('Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white));
                }),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
