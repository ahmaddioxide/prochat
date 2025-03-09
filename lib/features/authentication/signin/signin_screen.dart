import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prochat/features/authentication/signin/signin_controller.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final SignInController signinController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text('Sign in to ProChat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: signinController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () {
                  return TextFormField(
                    controller: signinController.passwordController,
                    obscureText: !signinController.isPasswordVisible.value,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: () {
                          signinController.isPasswordVisible.value =
                              !signinController.isPasswordVisible.value;
                        },
                        icon: signinController.isPasswordVisible.value
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
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await signinController.forgetPassword();
                      },
                      child: Text('Forgot Password?')),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () async {
                  signinController.isLoading.value = true;
                  await signinController.signIn();
                  signinController.isLoading.value = false;
                },
                child: Obx(() {
                  if (signinController.isLoading.value) {
                    return SizedBox(
                      height: 24,
                      width: 24,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }
                  return Text('Sign In',
                      style: TextStyle(fontSize: 18, color: Colors.white));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
