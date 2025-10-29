import 'package:flutter/material.dart';
import 'success_screen.dart'; // Import for navigation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  // Avatar selection - picking from 5 fun avatars!
  String? _selectedAvatar;
  final List<String> _avatars = [
    '😀', '😎', '🤩', '🥳', '🤗',
  ];
  
  // Password strength checker
  double _passwordStrength = 0.0;
  Color _passwordStrengthColor = Colors.red;
  String _passwordStrengthText = '';
  
  // Check how strong the password is
  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = 0.0;
        _passwordStrengthColor = Colors.red;
        _passwordStrengthText = '';
        return;
      }
      
      double strength = 0.0;
      
      // Check length
      if (password.length >= 6) strength += 0.25;
      if (password.length >= 8) strength += 0.25;
      
      // Check for numbers
      if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
      
      // Check for special characters
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
      
      _passwordStrength = strength;
      
      // Set color and text based on strength
      if (strength <= 0.25) {
        _passwordStrengthColor = Colors.red;
        _passwordStrengthText = 'Weak';
      } else if (strength <= 0.5) {
        _passwordStrengthColor = Colors.orange;
        _passwordStrengthText = 'Fair';
      } else if (strength <= 0.75) {
        _passwordStrengthColor = Colors.yellow;
        _passwordStrengthText = 'Good';
      } else {
        _passwordStrengthColor = Colors.green;
        _passwordStrengthText = 'Strong';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Date Picker Function
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // Check if the widget is still in the tree
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              userName: _nameController.text,
              userAvatar: _selectedAvatar,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account 🎉'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Animated Form Header
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tips_and_updates,
                          color: Colors.deepPurple[800]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Complete your adventure profile!',
                          style: TextStyle(
                            color: Colors.deepPurple[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Avatar Selection Section
                const Text(
                  'Choose Your Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 15),
                
                // Display avatars in a row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _avatars.map((avatar) {
                    bool isSelected = _selectedAvatar == avatar;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatar;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple : Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            avatar,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Adventure Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'What should we call you on this adventure?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'We need your email for adventure updates!';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Oops! That doesn\'t look like a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // DOB w/Calendar
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _selectDate,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'When did your adventure begin?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Pswd Field w/ Toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  onChanged: (value) {
                    _checkPasswordStrength(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Secret Password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Every adventurer needs a secret password!';
                    }
                    if (value.length < 6) {
                      return 'Make it stronger! At least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                
                // Password Strength Meter
                if (_passwordController.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Password Strength: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            _passwordStrengthText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _passwordStrengthColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _passwordStrengthColor,
                        ),
                        minHeight: 8,
                      ),
                    ],
                  ),
                const SizedBox(height: 30),

                // Submit Button w/ Loading Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isLoading ? 60 : double.infinity,
                  height: 60,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start My Adventure',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.rocket_launch, color: Colors.white),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }
}