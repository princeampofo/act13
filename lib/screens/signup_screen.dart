import 'package:flutter/material.dart';
import 'success_screen.dart'; // Import for navigation
import 'progress_tracker.dart'; // Import progress tracker

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
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
  
  // Achievement badges!
  List<String> _earnedBadges = [];
  
  // Progress tracker
  double _completionProgress = 0.0;
  
  // Field validation states for animations
  Map<String, bool> _fieldValidStates = {
    'name': false,
    'email': false,
    'dob': false,
    'password': false,
  };
  
  // Animation controllers for bounce and shake
  late AnimationController _nameShakeController;
  late AnimationController _emailShakeController;
  late AnimationController _dobShakeController;
  late AnimationController _passwordShakeController;
  
  late AnimationController _nameBounceController;
  late AnimationController _emailBounceController;
  late AnimationController _dobBounceController;
  late AnimationController _passwordBounceController;
  
  late Animation<double> _nameShakeAnimation;
  late Animation<double> _emailShakeAnimation;
  late Animation<double> _dobShakeAnimation;
  late Animation<double> _passwordShakeAnimation;
  
  late Animation<double> _nameBounceAnimation;
  late Animation<double> _emailBounceAnimation;
  late Animation<double> _dobBounceAnimation;
  late Animation<double> _passwordBounceAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize shake controllers
    _nameShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _emailShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _dobShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _passwordShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Initialize bounce controllers
    _nameBounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _emailBounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dobBounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _passwordBounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Create shake animations (side to side)
    _nameShakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _nameShakeController, curve: Curves.elasticIn),
    );
    _emailShakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _emailShakeController, curve: Curves.elasticIn),
    );
    _dobShakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _dobShakeController, curve: Curves.elasticIn),
    );
    _passwordShakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _passwordShakeController, curve: Curves.elasticIn),
    );
    
    // Create bounce animations (scale up and down)
    _nameBounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _nameBounceController, curve: Curves.easeOut),
    );
    _emailBounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _emailBounceController, curve: Curves.easeOut),
    );
    _dobBounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _dobBounceController, curve: Curves.easeOut),
    );
    _passwordBounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _passwordBounceController, curve: Curves.easeOut),
    );
  }
  
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
  
  // Check if user earned any badges
  void _checkBadges() {
    List<String> badges = [];
    
    // Strong Password Master badge
    if (_passwordStrength >= 0.75) {
      badges.add('Strong Password Master 🏆');
    }
    
    // Early Bird Special badge
    DateTime now = DateTime.now();
    if (now.hour < 12) {
      badges.add('The Early Bird Special 🐦');
    }
    
    // Profile Completer badge
    if (_nameController.text.isNotEmpty && 
        _emailController.text.isNotEmpty && 
        _dobController.text.isNotEmpty && 
        _passwordController.text.isNotEmpty &&
        _selectedAvatar != null) {
      badges.add('Profile Completer ⭐');
    }
    
    setState(() {
      _earnedBadges = badges;
    });
  }
  
  // Calculate how much of the form is completed
  void _updateProgress() {
    double progress = 0.0;
    
    if (_nameController.text.isNotEmpty) progress += 20;
    if (_emailController.text.isNotEmpty) progress += 20;
    if (_dobController.text.isNotEmpty) progress += 20;
    if (_passwordController.text.isNotEmpty) progress += 20;
    if (_selectedAvatar != null) progress += 20;
    
    setState(() {
      _completionProgress = progress;
    });
  }
  
  // Validate individual field and trigger animations
  void _validateField(String field, String value) {
    bool isValid = false;
    
    switch (field) {
      case 'name':
        isValid = value.isNotEmpty;
        if (isValid && !_fieldValidStates['name']!) {
          _triggerBounce(_nameBounceController);
        } else if (!isValid && _fieldValidStates['name']!) {
          _triggerShake(_nameShakeController);
        }
        break;
      case 'email':
        isValid = value.isNotEmpty && value.contains('@') && value.contains('.');
        if (isValid && !_fieldValidStates['email']!) {
          _triggerBounce(_emailBounceController);
        } else if (!isValid && value.isNotEmpty && _fieldValidStates['email']!) {
          _triggerShake(_emailShakeController);
        }
        break;
      case 'password':
        isValid = value.isNotEmpty && value.length >= 6;
        if (isValid && !_fieldValidStates['password']!) {
          _triggerBounce(_passwordBounceController);
        } else if (!isValid && value.isNotEmpty && _fieldValidStates['password']!) {
          _triggerShake(_passwordShakeController);
        }
        break;
    }
    
    setState(() {
      _fieldValidStates[field] = isValid;
    });
  }
  
  // Trigger shake animation
  void _triggerShake(AnimationController controller) {
    controller.reset();
    controller.forward().then((_) => controller.reverse());
  }
  
  // Trigger bounce animation
  void _triggerBounce(AnimationController controller) {
    controller.reset();
    controller.forward().then((_) => controller.reverse());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    
    // Dispose animation controllers
    _nameShakeController.dispose();
    _emailShakeController.dispose();
    _dobShakeController.dispose();
    _passwordShakeController.dispose();
    
    _nameBounceController.dispose();
    _emailBounceController.dispose();
    _dobBounceController.dispose();
    _passwordBounceController.dispose();
    
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
        _fieldValidStates['dob'] = true;
      });
      _triggerBounce(_dobBounceController);
      _updateProgress();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Check which badges they earned!
      _checkBadges();

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              userName: _nameController.text,
              userAvatar: _selectedAvatar,
              badges: _earnedBadges,
            ),
          ),
        );
      });
    } else {
      // Shake all invalid fields
      if (_nameController.text.isEmpty) _triggerShake(_nameShakeController);
      if (_emailController.text.isEmpty || !_fieldValidStates['email']!) {
        _triggerShake(_emailShakeController);
      }
      if (_dobController.text.isEmpty) _triggerShake(_dobShakeController);
      if (_passwordController.text.isEmpty || !_fieldValidStates['password']!) {
        _triggerShake(_passwordShakeController);
      }
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
                
                // Progress Tracker
                ProgressTracker(progress: _completionProgress),
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
                        _updateProgress();
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

                // Name Field with animations
                AnimatedBuilder(
                  animation: Listenable.merge([_nameShakeAnimation, _nameBounceAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _nameShakeAnimation.value * 
                        ((_nameShakeController.value * 4).floor() % 2 == 0 ? 1 : -1),
                        0,
                      ),
                      child: Transform.scale(
                        scale: _nameBounceAnimation.value,
                        child: _buildAnimatedTextField(
                          controller: _nameController,
                          label: 'Adventure Name',
                          icon: Icons.person,
                          fieldKey: 'name',
                          isValid: _fieldValidStates['name']!,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'What should we call you on this adventure?';
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Email Field with animations
                AnimatedBuilder(
                  animation: Listenable.merge([_emailShakeAnimation, _emailBounceAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _emailShakeAnimation.value * 
                        ((_emailShakeController.value * 4).floor() % 2 == 0 ? 1 : -1),
                        0,
                      ),
                      child: Transform.scale(
                        scale: _emailBounceAnimation.value,
                        child: _buildAnimatedTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email,
                          fieldKey: 'email',
                          isValid: _fieldValidStates['email']!,
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
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // DOB with animations
                AnimatedBuilder(
                  animation: Listenable.merge([_dobShakeAnimation, _dobBounceAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _dobShakeAnimation.value * 
                        ((_dobShakeController.value * 4).floor() % 2 == 0 ? 1 : -1),
                        0,
                      ),
                      child: Transform.scale(
                        scale: _dobBounceAnimation.value,
                        child: TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_fieldValidStates['dob']!)
                                  const Icon(Icons.check_circle, color: Colors.green),
                                IconButton(
                                  icon: const Icon(Icons.date_range),
                                  onPressed: _selectDate,
                                ),
                              ],
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'When did your adventure begin?';
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Password Field with animations
                AnimatedBuilder(
                  animation: Listenable.merge([_passwordShakeAnimation, _passwordBounceAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _passwordShakeAnimation.value * 
                        ((_passwordShakeController.value * 4).floor() % 2 == 0 ? 1 : -1),
                        0,
                      ),
                      child: Transform.scale(
                        scale: _passwordBounceAnimation.value,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          onChanged: (value) {
                            _checkPasswordStrength(value);
                            _updateProgress();
                            _validateField('password', value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Secret Password',
                            prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_fieldValidStates['password']!)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.check_circle, color: Colors.green),
                                  ),
                                IconButton(
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
                              ],
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
                      ),
                    );
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

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String fieldKey,
    required bool isValid,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        _updateProgress();
        _validateField(fieldKey, value);
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        suffixIcon: isValid
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
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