import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../main_navigation.dart';
import 'signup_screen.dart';
import '../admin/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // FIREBASE LOGIN
  // ============================================================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // ----------------------------------------------------------
    // Validate fields
    // ----------------------------------------------------------

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your email and password.',
          ),
        ),
      );
      return;
    }

    // ----------------------------------------------------------
    // Start loading
    // ----------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    final appState = context.read<AppState>();

    // ----------------------------------------------------------
    // IMPORTANT:
    // Use Firebase login, NOT the old local login.
    // ----------------------------------------------------------

    final success = await appState.loginWithFirebase(
      email,
      password,
    );

    // ----------------------------------------------------------
    // Stop loading
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;
    });

    // ----------------------------------------------------------
    // Login failed
    // ----------------------------------------------------------

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login failed. Please check your email and password.',
          ),
        ),
      );
      return;
    }

    // ----------------------------------------------------------
    // Login successful
    // ----------------------------------------------------------

    final user = appState.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login succeeded, but user profile could not be loaded.',
          ),
        ),
      );
      return;
    }

    // ----------------------------------------------------------
    // ADMIN
    // ----------------------------------------------------------

    if (user.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // NORMAL USER / ARTIST
    // ----------------------------------------------------------

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
    );
  }

  // ============================================================
  // BUILD UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // ------------------------------------------------
                      // LOGO
                      // ------------------------------------------------
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/artbridge_logo.png',
                              width: 260,
                              height: 180,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Learn. Create. Share.',
                              style: TextStyle(
                                color: AppTheme.softGray,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                  const SizedBox(height: 45),

                  // ------------------------------------------------
                  // LOGIN TITLE
                  // ------------------------------------------------

                  Text(
                    'Welcome Back',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.charcoal,
                        ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Log in to continue your ArtBridge journey.',
                    style: TextStyle(
                      color: AppTheme.softGray,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ------------------------------------------------
                  // EMAIL
                  // ------------------------------------------------

                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    textInputAction:
                        TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText:
                          'Enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // PASSWORD
                  // ------------------------------------------------

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    textInputAction:
                        TextInputAction.done,
                    onSubmitted: (_) {
                      if (!isLoading) {
                        login();
                      }
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons
                                  .visibility_outlined
                              : Icons
                                  .visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ------------------------------------------------
                  // LOGIN BUTTON
                  // ------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : login,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------
                  // SIGN UP
                  // ------------------------------------------------

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppTheme.softGray,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // INFORMATION
                  // ------------------------------------------------

                  Center(
                    child: Text(
                      'Your account is securely managed by Firebase.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.softGray
                            .withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}