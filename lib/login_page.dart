import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLogin = true;
  bool _isLoading = false;
  
  String _email = '';
  String _password = '';
  String _name = '';
  String _rollNumber = '';
  String _domain = 'Web/App Developer';
  int _batch = 2025;
  String _error = '';

  final List<String> _domains = [
    'Public Relation Management',
    'Content Writer',
    'Graphic Designer',
    'Photographer',
    'Web/App Developer',
    'Video Editor',
  ];

  final List<int> _years = [2022, 2023, 2024, 2025, 2026];

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    _formKey.currentState!.save();
    
    dynamic result;
    if (_isLogin) {
      result = await _auth.signIn(_email, _password);
    } else {
      result = await _auth.signUp(
        email: _email,
        password: _password,
        name: _name,
        rollNumber: _rollNumber,
        domain: _domain,
        batch: _batch,
      );
    }

    if (result == null) {
      setState(() {
        _error = 'Could not sign in with those credentials';
        _isLoading = false;
      });
    }
    // Auth state changes will handle navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              // Logo/Title
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF4A0404),
                child: Icon(Icons.ac_unit, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              Text(
                'HITIAN INSIDE',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A0404),
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                _isLogin ? 'Welcome back, Hitian!' : 'Join the Inner Circle',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isLogin)
                      TextFormField(
                        decoration: _inputDecoration('Full Name', Icons.person_outline),
                        style: GoogleFonts.outfit(),
                        validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                        onSaved: (val) => _name = val!,
                      ),
                    if (!_isLogin) const SizedBox(height: 20),
                    if (!_isLogin)
                      TextFormField(
                        decoration: _inputDecoration('Roll Number', Icons.badge_outlined),
                        style: GoogleFonts.outfit(),
                        validator: (val) => val!.isEmpty ? 'Enter your roll number' : null,
                        onSaved: (val) => _rollNumber = val!,
                      ),
                    if (!_isLogin) const SizedBox(height: 20),
                    if (!_isLogin)
                      DropdownButtonFormField<String>(
                        initialValue: _domain,
                        decoration: _inputDecoration('Domain', Icons.category_outlined),
                        items: _domains.map((String domain) {
                          return DropdownMenuItem<String>(
                            value: domain,
                            child: Text(domain, style: GoogleFonts.outfit()),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _domain = val!),
                        onSaved: (val) => _domain = val!,
                      ),
                    if (!_isLogin) const SizedBox(height: 20),
                    if (!_isLogin)
                      DropdownButtonFormField<int>(
                        initialValue: _batch,
                        decoration: _inputDecoration('Batch', Icons.calendar_month_outlined),
                        items: _years.map((int year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text('Batch $year-${year + 1}', style: GoogleFonts.outfit()),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _batch = val!),
                        onSaved: (val) => _batch = val!,
                      ),
                    if (!_isLogin) const SizedBox(height: 20),
                    TextFormField(
                      decoration: _inputDecoration('Email Address', Icons.email_outlined),
                      style: GoogleFonts.outfit(),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onSaved: (val) => _email = val!,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: _inputDecoration('Password', Icons.lock_outline),
                      style: GoogleFonts.outfit(),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onSaved: (val) => _password = val!,
                    ),
                  ],
                ),
              ),
              
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(_error, style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),

              const SizedBox(height: 40),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A0404),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Toggle Login/Signup
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF4A0404),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.outfit(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: const Color(0xFF4A0404)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4A0404), width: 2),
      ),
    );
  }
}
