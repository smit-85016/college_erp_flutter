// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FForgotPasswordScreen extends StatefulWidget {
//   const FForgotPasswordScreen({super.key});

//   @override
//   State<FForgotPasswordScreen> createState() => _FForgotPasswordScreenState();
// }

// class _FForgotPasswordScreenState extends State<FForgotPasswordScreen> {
//   static const Color _blue = Color(0xFF185FA5);
//   static const Color _blueBg = Color(0xFFE6F1FB);

//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _changePassword() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       // Sign in with email and new password to verify the account exists,
//       // then update the password directly.
//       // Since user forgot password, we use admin-style update via re-auth workaround:
//       // We sign in with the provided email using a temporary credential approach.

//       // Step 1: Get the current user if already signed in, else sign in fresh
//       UserCredential? credential;
//       final currentUser = FirebaseAuth.instance.currentUser;

//       if (currentUser != null && currentUser.email == _emailController.text.trim()) {
//         // Already signed in as this user — just update password
//         await currentUser.updatePassword(_newPasswordController.text.trim());
//       } else {
//         // User is not signed in — we need to re-authenticate.
//         // Since they forgot password, use Firebase's signInWithEmailAndPassword
//         // with a dummy attempt won't work. Instead, we use updatePassword after
//         // signing them in with their OLD password — but they forgot it.
//         //
//         // SOLUTION: Use Firebase Admin via a Cloud Function, OR
//         // sign in anonymously and call a backend. For a simple local-only approach,
//         // we send a password reset email as fallback.
//         //
//         // Best simple approach without a backend:
//         // Send reset email to the provided address.
//         await FirebaseAuth.instance.sendPasswordResetEmail(
//           email: _emailController.text.trim(),
//         );

//         if (mounted) {
//           setState(() => _isLoading = false);
//           _showDialog(
//             title: 'Reset Email Sent',
//             message:
//                 'A password reset link has been sent to ${_emailController.text.trim()}. '
//                 'Please check your inbox.',
//             isSuccess: true,
//           );
//         }
//         return;
//       }

//       if (mounted) {
//         setState(() => _isLoading = false);
//         _showDialog(
//           title: 'Password Changed!',
//           message: 'Your password has been updated successfully.',
//           isSuccess: true,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() => _isLoading = false);
//       String message = 'Something went wrong. Please try again.';
//       if (e.code == 'user-not-found') {
//         message = 'No account found with this email address.';
//       } else if (e.code == 'requires-recent-login') {
//         message = 'Please log in again before changing your password.';
//       } else if (e.code == 'weak-password') {
//         message = 'Password must be at least 6 characters.';
//       } else if (e.code == 'invalid-email') {
//         message = 'Please enter a valid email address.';
//       }
//       _showDialog(title: 'Error', message: message, isSuccess: false);
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showDialog(
//         title: 'Error',
//         message: 'Something went wrong. Please try again.',
//         isSuccess: false,
//       );
//     }
//   }

//   void _showDialog({
//     required String title,
//     required String message,
//     required bool isSuccess,
//   }) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(
//               isSuccess ? Icons.check_circle : Icons.error,
//               color: isSuccess ? Colors.green : Colors.red,
//             ),
//             const SizedBox(width: 8),
//             Text(title,
//                 style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//           ],
//         ),
//         content:
//             Text(message, style: GoogleFonts.poppins(fontSize: 14)),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // close dialog
//               if (isSuccess) Navigator.pop(context); // go back to login
//             },
//             child: Text('OK',
//                 style: GoogleFonts.poppins(
//                     color: _blue, fontWeight: FontWeight.w600)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _blueBg,
//       appBar: AppBar(
//         backgroundColor: _blue,
//         title: Text(
//           'Forgot Password',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),

//                 // Header illustration
//                 Center(
//                   child: Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: _blue.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.lock_reset,
//                         size: 54, color: _blue),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 Center(
//                   child: Text(
//                     'Reset Your Password',
//                     style: GoogleFonts.poppins(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: _blue,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Center(
//                   child: Text(
//                     'Enter your registered email and a new password.',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: 13,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 36),

//                 // Email field
//                 _buildLabel('Registered Email'),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: _inputDecoration(
//                     hint: 'Enter your email',
//                     icon: Icons.email_outlined,
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty) return 'Email is required';
//                     if (!val.contains('@')) return 'Enter a valid email';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // New Password field
//                 _buildLabel('New Password'),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _newPasswordController,
//                   obscureText: _obscureNew,
//                   decoration: _inputDecoration(
//                     hint: 'Enter new password',
//                     icon: Icons.lock_outline,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureNew
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () =>
//                           setState(() => _obscureNew = !_obscureNew),
//                     ),
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty) return 'Password is required';
//                     if (val.length < 6) return 'Minimum 6 characters';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Confirm Password field
//                 _buildLabel('Confirm New Password'),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: _obscureConfirm,
//                   decoration: _inputDecoration(
//                     hint: 'Re-enter new password',
//                     icon: Icons.lock_outline,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureConfirm
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () =>
//                           setState(() => _obscureConfirm = !_obscureConfirm),
//                     ),
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty)
//                       return 'Please confirm your password';
//                     if (val != _newPasswordController.text)
//                       return 'Passwords do not match';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 36),

//                 // Submit button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _changePassword,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                             'Reset Password',
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Back to login
//                 Center(
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Back to Login',
//                       style: GoogleFonts.poppins(
//                         color: _blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: GoogleFonts.poppins(
//         fontSize: 13,
//         fontWeight: FontWeight.w600,
//         color: Colors.grey[700],
//       ),
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String hint,
//     required IconData icon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
//       prefixIcon: Icon(icon, color: _blue, size: 20),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: _blue, width: 1.5),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1.5),
//       ),
//     );
//   }
// }
