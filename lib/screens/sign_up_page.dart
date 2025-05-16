import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_fyp/models/user_model.dart';
import 'glassmorphism_container.dart';
import 'users_list_screen.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _placeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance.collection('public_users').doc();

      final appUser = AppUser(
        uid: docRef.id,
        name: _nameController.text.trim(),
        phone: _formatPhone(_phoneController.text.trim()),
        place: _placeController.text.trim(),
        createdAt: DateTime.now(),
        isAdmin: false,
      );

      await docRef.set(appUser.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          duration: Duration(seconds: 3),
        ),
      );

      _formKey.currentState!.reset();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatPhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!phone.startsWith('+92')) {
      if (phone.startsWith('0')) {
        return '+92${phone.substring(1)}';
      }
      return '+92$phone';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Public Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: GlassmorphismContainer(
                borderRadius: 20,
                blur: 20,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Create Your Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _buildInputDecoration('Full Name'),
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _buildInputDecoration(
                              'Phone Number',
                              hint: '+92XXXXXXXXXX'
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter phone';
                            if (!value.startsWith('+92') && !value.startsWith('0'))
                              return 'Must start with +92 or 0';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _placeController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _buildInputDecoration('City/Place'),
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter location' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                              'REGISTER NOW',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UsersListScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.people, color: Colors.white),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
    );
  }
}