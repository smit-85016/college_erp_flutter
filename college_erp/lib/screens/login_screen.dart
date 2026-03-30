import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../main.dart';
import 'auth/register_screen.dart';
import '../screens/faculty_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isStudent = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (result['error'] != null) {
      _showSnack(result['error'], const Color(0xFFE24B4A));
      return;
    }

    final user = result['user'] as AppUser;
    if (user.role == UserRole.faculty) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const FacultyDashboardScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MainShell()));
    }
  }

  void _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showSnack('Enter your email first, then tap Forgot password.', const Color(0xFFE24B4A));
      return;
    }
    final err = await AuthService.sendPasswordReset(_emailController.text);
    if (!mounted) return;
    if (err != null) {
      _showSnack(err, const Color(0xFFE24B4A));
    } else {
      _showSnack('Password reset email sent! Check your inbox.', AppTheme.primary);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.nunito()),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Logo
                Center(
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                        color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.school, color: Colors.white, size: 38),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: Text('Campus ERP',
                    style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
                Center(child: Text('JG University',
                    style: GoogleFonts.nunito(fontSize: 14, color: AppTheme.textSecondary))),
                const SizedBox(height: 36),

                // Toggle
                Container(
                  decoration: BoxDecoration(
                      color: AppTheme.border.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(4),
                  child: Row(children: [
                    Expanded(child: _ToggleBtn('Student', _isStudent, () => setState(() {
                      _isStudent = true;
                      _emailController.clear(); _passwordController.clear();
                    }))),
                    Expanded(child: _ToggleBtn('Faculty', !_isStudent, () => setState(() {
                      _isStudent = false;
                      _emailController.clear(); _passwordController.clear();
                    }))),
                  ]),
                ),
                const SizedBox(height: 28),

                // Email field
                Text('Email Address', style: GoogleFonts.nunito(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.nunito(fontSize: 14),
                  decoration: _inputDecor(
                      hint: _isStudent ? 'Enter your college email' : 'Enter your faculty email',
                      icon: Icons.email_outlined),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Password field
                Text('Password', style: GoogleFonts.nunito(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.nunito(fontSize: 14),
                  decoration: _inputDecor(hint: 'Enter your password', icon: Icons.lock_outline)
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppTheme.textSecondary, size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your password';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text('Forgot password?',
                        style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.primary)),
                  ),
                ),
                const SizedBox(height: 8),

                // Login button
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(
                            _isStudent ? 'Login as Student' : 'Login as Faculty',
                            style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),

                // Register link — students only
                if (_isStudent) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account? ",
                          style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary)),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen())),
                        child: Text('Register here',
                            style: GoogleFonts.nunito(fontSize: 13,
                                fontWeight: FontWeight.w700, color: AppTheme.primary)),
                      ),
                    ]),
                  ),
                ],

                const SizedBox(height: 32),
                Center(child: Text('v1.0 · JG University Campus ERP',
                    style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ToggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(child: Text(label, style: GoogleFonts.nunito(
            fontSize: 14, fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppTheme.textSecondary))),
      ),
    );
  }

  InputDecoration _inputDecor({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary),
      prefixIcon: Icon(icon, size: 20, color: AppTheme.textSecondary),
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5)),
    );
  }
}
