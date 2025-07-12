import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final String emailId;
  final String password;

  const Login({super.key, required this.emailId, required this.password});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(
      text: emailId,
    );
    final TextEditingController passwordController = TextEditingController(
      text: password,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Simulate form submission
                String email = emailController.text;
                String password = passwordController.text;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Submitted: $email / $password')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
