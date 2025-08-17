import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Assumes LoginPage is in main.dart

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _phoneError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreed = false;
  bool _loading = false;

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() {
      _emailError = email.isEmpty ? 'Please enter your email.' : null;
      _passwordError = password.isEmpty
          ? 'Please enter your password.'
          : (password.length < 8 ? 'Password must be at least 8 characters.' : null);
      _confirmPasswordError = confirmPassword.isEmpty
          ? 'Please confirm your password.'
          : (confirmPassword != password ? 'Passwords do not match.' : null);
      _phoneError = phone.isEmpty ? 'Please enter your phone number.' : null;
    });

    if (_emailError != null || _passwordError != null || _confirmPasswordError != null || _phoneError != null) {
      return;
    }

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Signup failed")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Image(image: AssetImage('images/logo.jpg'), height: 110),
                    const SizedBox(height: 32),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4EC),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 28),

                          // Email
                          _buildLabeledField('Email ID', _emailController, 'Enter your email...',
                              errorText: _emailError),

                          // Password
                          _buildLabeledPasswordField(
                            label: 'Password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                            errorText: _passwordError,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Minimum 8 characters',
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ),

                          // Confirm Password
                          _buildLabeledPasswordField(
                            label: 'Confirm Password',
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            toggleVisibility: () =>
                                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            errorText: _confirmPasswordError,
                          ),

                          // Phone Number
                          _buildLabeledField('Phone Number', _phoneController, 'Enter your phone number.',
                              keyboardType: TextInputType.phone, errorText: _phoneError),

                          const SizedBox(height: 12),

                          // Terms
                          Row(
                            children: [
                              Checkbox(
                                value: _agreed,
                                onChanged: (val) => setState(() => _agreed = val ?? false),
                              ),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(color: Colors.black87, fontSize: 13),
                                    children: [
                                      TextSpan(text: 'I have read and agreed to the '),
                                      TextSpan(
                                        text: 'terms and conditions',
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Submit
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3BA05B),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _agreed && !_loading ? _signup : null,
                              child: _loading
                                  ? const SizedBox(
                                      height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                                  : const Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Back to login
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'back to login',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text, String? errorText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ),
        ],
      ),
    );
  }

  Widget _buildLabeledPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: 'Enter your password...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: toggleVisibility,
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}