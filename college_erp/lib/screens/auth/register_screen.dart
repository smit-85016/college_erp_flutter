import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import 'pending_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _rollCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _rollValidated = false;
  bool _isValidatingRoll = false;
  Map<String, dynamic>? _rollData;

  @override
  void dispose() {
    _nameCtrl.dispose(); _rollCtrl.dispose(); _emailCtrl.dispose();
    _phoneCtrl.dispose(); _passCtrl.dispose(); _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _validateRoll() async {
    if (_rollCtrl.text.trim().isEmpty) return;
    setState(() => _isValidatingRoll = true);

    final data = await AuthService.validateRollNumber(_rollCtrl.text.trim());
    setState(() {
      _isValidatingRoll = false;
      _rollData = data;
      _rollValidated = data != null;
    });

    if (data == null) {
      _showSnack('Roll number not found or already registered. Contact your faculty.', const Color(0xFFE24B4A));
    } else {
      _showSnack('Roll number verified! Dept: ${data['department']} · ${data['semester']}', AppTheme.primary);
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_rollValidated) {
      _showSnack('Please verify your roll number first.', const Color(0xFFE24B4A));
      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthService.registerStudent(
      email: _emailCtrl.text,
      password: _passCtrl.text,
      name: _nameCtrl.text,
      rollNo: _rollCtrl.text,
      phone: _phoneCtrl.text,
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (error != null) {
      _showSnack(error, const Color(0xFFE24B4A));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => PendingScreen(name: _nameCtrl.text)));
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
      appBar: AppBar(
        title: Text('Student Registration',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppTheme.border)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline, size: 18, color: AppTheme.primaryDark),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'Your roll number is given to you by your college before registration. '
                  'It links your account to your class teacher who will approve your registration.',
                  style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.primaryDark, height: 1.5),
                )),
              ]),
            ),
            const SizedBox(height: 24),

            // Roll number with verify button
            _FieldLabel('Roll Number'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _rollCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.nunito(fontSize: 14),
                  onChanged: (_) => setState(() { _rollValidated = false; _rollData = null; }),
                  decoration: _inputDecor(hint: 'e.g. 22IT0045', icon: Icons.badge_outlined).copyWith(
                    suffixIcon: _rollValidated
                        ? const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 20)
                        : null,
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Enter your roll number' : null,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isValidatingRoll ? null : _validateRoll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rollValidated ? const Color(0xFF1D9E75) : const Color(0xFF185FA5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: _isValidatingRoll
                      ? const SizedBox(width: 18, height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_rollValidated ? 'Verified ✓' : 'Verify',
                          style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),

            // Show detected dept/semester
            if (_rollData != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.school_outlined, size: 14, color: AppTheme.primaryDark),
                  const SizedBox(width: 6),
                  Text('${_rollData!['department']} · ${_rollData!['semester']}',
                      style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
                ]),
              ),
            ],
            const SizedBox(height: 18),

            _FieldLabel('Full Name'),
            const SizedBox(height: 8),
            _Field(ctrl: _nameCtrl, hint: 'Enter your full name', icon: Icons.person_outline,
                validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null),
            const SizedBox(height: 18),

            _FieldLabel('College Email'),
            const SizedBox(height: 8),
            _Field(ctrl: _emailCtrl, hint: 'yourname@jgu.ac.in', icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter your email';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                }),
            const SizedBox(height: 18),

            _FieldLabel('Phone Number'),
            const SizedBox(height: 8),
            _Field(ctrl: _phoneCtrl, hint: '+91 98765 43210', icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Enter your phone number' : null),
            const SizedBox(height: 18),

            _FieldLabel('Create Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passCtrl,
              obscureText: _obscurePass,
              style: GoogleFonts.nunito(fontSize: 14),
              decoration: _inputDecor(hint: 'Minimum 6 characters', icon: Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppTheme.textSecondary, size: 20),
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Create a password';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 18),

            _FieldLabel('Confirm Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPassCtrl,
              obscureText: _obscureConfirm,
              style: GoogleFonts.nunito(fontSize: 14),
              decoration: _inputDecor(hint: 'Re-enter your password', icon: Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppTheme.textSecondary, size: 20),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Confirm your password';
                if (v != _passCtrl.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text('Submit Registration',
                        style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _FieldLabel(String text) => Text(text,
      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary));

  Widget _Field({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: GoogleFonts.nunito(fontSize: 14),
      decoration: _inputDecor(hint: hint, icon: icon),
      validator: validator,
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
