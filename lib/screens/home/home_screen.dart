import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';
import '../auth/login_screen.dart';
import '../courses/courses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final appState = context.read<AppState>();

    // Show a small loading dialog while Firebase signs out.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await appState.logoutFromFirebase();
    } finally {
      // Close loading dialog.
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    // Always return to login screen after logout.
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void _showProfileMenu(
    BuildContext context,
    AppState appState,
  ) {
    final user = appState.currentUser;

    if (user == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.warmCream,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppTheme.softGray.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 24),

                // Profile icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppTheme.oliveGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 38,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.softGray,
                  ),
                ),

                const SizedBox(height: 12),

                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.oliveGreen.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getRoleName(user.role),
                    style: const TextStyle(
                      color: AppTheme.darkOlive,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Close bottom sheet first.
                      Navigator.of(sheetContext).pop();

                      // Then perform logout.
                      await _logout(context);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkOlive,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRoleName(UserRole? role) {
    switch (role) {
      case UserRole.artist:
        return 'Artist';

      case UserRole.admin:
        return 'Admin';

      case UserRole.user:
        return 'User';

      case null:
        return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // HEADER
              // ============================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        user == null
                            ? 'Welcome to'
                            : 'Welcome, ${user.name}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.softGray,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const BrandLogo(
                        width: 150,
                        height: 55,
                      ),
                    ],
                  ),

                  // CLICKABLE PROFILE BUTTON
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _showProfileMenu(
                          context,
                          appState,
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(30),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: AppTheme.oliveGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ============================================================
              // HERO SECTION
              // ============================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.darkOlive,
                      AppTheme.oliveGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learn. Create. Share.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Discover your creativity, learn new skills, '
                      'and turn your art into opportunities.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 22),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const CoursesScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            AppTheme.darkOlive,
                        minimumSize:
                            const Size(150, 48),
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Learning',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============================================================
              // SECTION TITLE
              // ============================================================

              const Text(
                'What can you do?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.charcoal,
                ),
              ),

              const SizedBox(height: 15),

              // ============================================================
              // FEATURE CARDS
              // ============================================================

              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Learn',
                      subtitle:
                          'Build creative skills',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.brush_rounded,
                      title: 'Create',
                      subtitle:
                          'Turn ideas into art',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.upload_rounded,
                      title: 'Sell',
                      subtitle:
                          'Share your artwork',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.shopping_bag_rounded,
                      title: 'Buy',
                      subtitle:
                          'Support artists',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // ============================================================
              // WHY ARTBRIDGE
              // ============================================================

              const Text(
                'Why ArtBridge?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.charcoal,
                ),
              ),

              const SizedBox(height: 15),

              const BenefitItem(
                icon: Icons.school_rounded,
                title: 'Learn New Skills',
                description:
                    'Access practical art courses and '
                    'develop your creative abilities.',
              ),

              const SizedBox(height: 12),

              const BenefitItem(
                icon: Icons.people_alt_rounded,
                title: 'Join a Community',
                description:
                    'Connect with people who share '
                    'your passion for creativity.',
              ),

              const SizedBox(height: 12),

              const BenefitItem(
                icon: Icons.storefront_rounded,
                title: 'Create Opportunities',
                description:
                    'Approved artists can showcase '
                    'and sell their artwork.',
              ),

              const SizedBox(height: 35),

              // ============================================================
              // YOUR JOURNEY
              // ============================================================

              const Text(
                'Your ArtBridge Journey',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.charcoal,
                ),
              ),

              const SizedBox(height: 15),

              const JourneyStep(
                number: '01',
                icon: Icons.menu_book_rounded,
                title: 'Learn',
                description:
                    'Complete at least one ArtBridge course.',
              ),

              const SizedBox(height: 12),

              const JourneyStep(
                number: '02',
                icon: Icons.person_add_alt_1_rounded,
                title: 'Apply',
                description:
                    'Apply to become an ArtBridge artist.',
              ),

              const SizedBox(height: 12),

              const JourneyStep(
                number: '03',
                icon: Icons.verified_rounded,
                title: 'Get Approved',
                description:
                    'Admin reviews and approves your application.',
              ),

              const SizedBox(height: 12),

              const JourneyStep(
                number: '04',
                icon: Icons.palette_rounded,
                title: 'Create & Sell',
                description:
                    'Upload artwork and share it with buyers.',
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FEATURE CARD
// ============================================================================

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.oliveGreen.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.oliveGreen.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 25,
              color: AppTheme.oliveGreen,
            ),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppTheme.charcoal,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.softGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BENEFIT ITEM
// ============================================================================

class BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.oliveGreen.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AppTheme.oliveGreen,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.charcoal,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppTheme.softGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// JOURNEY STEP
// ============================================================================

class JourneyStep extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const JourneyStep({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.darkOlive,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.oliveGreen.withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.oliveGreen,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.charcoal,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppTheme.softGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}