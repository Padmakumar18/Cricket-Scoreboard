import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String userName;
  final String password;

  const LoginPage({super.key, required this.userName, required this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.userName);
    passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginPage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'User Name'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  print('Validating User Name: $value');
                  if (value == null || value.trim().isEmpty) {
                    return 'User Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String userName = emailController.text;
                        String password = passwordController.text;

                        print('Email: $userName');
                        print('Password: $password');

                        emailController.clear();
                        passwordController.clear();
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const Text("or"),
                  ElevatedButton(
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();

                      Navigator.pushReplacementNamed(context, '/SignupPage');
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
