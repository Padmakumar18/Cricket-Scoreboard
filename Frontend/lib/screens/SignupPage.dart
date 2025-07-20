import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFieldKey =
      GlobalKey<FormFieldState>(); // ✅ Unique key for phone field

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final number = _numberController.text.trim();
      final password = _passwordController.text.trim();
      final otp = _otpController.text.trim();

      print('Name: $name');
      print('Number: $number');
      print('Password: $password');
      print('OTP: $otp');

      _nameController.clear();
      _numberController.clear();
      _passwordController.clear();
      _otpController.clear();
    }
  }

  void _sendOtp() {
    final isPhoneValid = _phoneFieldKey.currentState?.validate() ?? false;

    if (isPhoneValid) {
      final number = _numberController.text.trim();
      print('OTP sent to $number');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP sent to $number')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid phone number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your name'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Minimum 6 characters'
                    : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      key: _phoneFieldKey,
                      controller: _numberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter phone number';
                        } else if (!RegExp(
                          r'^[0-9]{10}$',
                        ).hasMatch(value.trim())) {
                          return 'Phone number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _sendOtp,
                    child: const Text('Send OTP'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // OTP Field
              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter OTP';
                  } else if (value.trim().length != 6) {
                    return 'Enter valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Sign Up'),
                  ),
                  const Text("or"),
                  ElevatedButton(
                    onPressed: () {
                      _nameController.clear();
                      _numberController.clear();
                      _passwordController.clear();
                      _otpController.clear();
                      Navigator.pushReplacementNamed(context, '/LoginPage');
                    },
                    child: const Text('Login'),
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
