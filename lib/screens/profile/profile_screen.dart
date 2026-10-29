import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';

import '../artist/artist_upload_screen.dart';
import '../auth/login_screen.dart';
import 'artist_application_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout(
    BuildContext context,
    AppState appState,
  ) async {
    // Ask for confirmation first.
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.warmCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of ArtBridge?',
            style: TextStyle(
              color: AppTheme.softGray,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.softGray,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkOlive,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    // Show loading dialog.
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppTheme.oliveGreen,
          ),
        );
      },
    );

    try {
      // IMPORTANT:
      // Use Firebase logout.
      await appState.logoutFromFirebase();

      if (!context.mounted) return;

      // Close loading dialog.
      Navigator.of(context).pop();

      // Completely remove the logged-in navigation stack.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Profile logout error: $e');

      if (!context.mounted) return;

      // Close loading dialog.
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to log out. Please try again.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // ROLE NAME
  // ============================================================

  String _roleName(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'User';

      case UserRole.artist:
        return 'Artist';

      case UserRole.admin:
        return 'Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;

    // If there is no logged-in user, show loading briefly.
    if (user == null) {
      return const Scaffold(
        backgroundColor: AppTheme.warmCream,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.oliveGreen,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ============================================================
            // BRAND LOGO
            // ============================================================

            const BrandLogo(
              width: 145,
              height: 60,
            ),

            const SizedBox(height: 4),

            // ============================================================
            // PAGE TITLE
            // ============================================================

            Text(
              'My Profile',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    color: AppTheme.charcoal,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // PROFILE HEADER
            // ============================================================

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        AppTheme.oliveGreen.withValues(
                      alpha: 0.12,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 34,
                      color: AppTheme.oliveGreen,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.charcoal,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.softGray,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.oliveGreen.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            _roleName(user.role),
                            style: const TextStyle(
                              color: AppTheme.oliveGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ============================================================
            // ARTIST ACCOUNT SECTION
            // ============================================================

            if (user.isArtist) ...[
              const _SectionTitle(
                title: 'Artist Account',
              ),

              const SizedBox(height: 10),

              _ProfileActionCard(
                icon: Icons.palette_outlined,
                title: 'Sell My Art',
                subtitle:
                    'Upload and showcase your artwork.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ArtistUploadScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],

            // ============================================================
            // BECOME AN ARTIST SECTION
            // ============================================================

            if (!user.isArtist) ...[
              const _SectionTitle(
                title: 'Become an Artist',
              ),

              const SizedBox(height: 10),

              _ArtistApplicationCard(
                user: user,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ArtistApplicationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],

            // ============================================================
            // MY LEARNING
            // ============================================================

            const _SectionTitle(
              title: 'My Learning',
            ),

            const SizedBox(height: 10),

            _ProfileActionCard(
              icon: Icons.school_outlined,
              title: 'My Courses',
              subtitle:
                  'View your enrolled and completed courses.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'My Courses will be available here.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ============================================================
            // SAVED ARTWORKS
            // ============================================================

            _ProfileActionCard(
              icon: Icons.favorite_border,
              title: 'Saved Artworks',
              subtitle:
                  'View artworks you saved.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Saved Artworks will be available here.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ============================================================
            // MY ORDERS
            // ============================================================

            _ProfileActionCard(
              icon: Icons.receipt_long_outlined,
              title: 'My Orders',
              subtitle:
                  'View your artwork purchases.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'My Orders will be available here.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ============================================================
            // ACCOUNT SETTINGS
            // ============================================================

            const _SectionTitle(
              title: 'Account',
            ),

            const SizedBox(height: 10),

            _ProfileActionCard(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle:
                  'Update your profile information.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Edit Profile will be available here.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _ProfileActionCard(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle:
                  'Manage your account settings.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Settings will be available here.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ============================================================
            // LOGOUT
            // ============================================================

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _logout(
                    context,
                    appState,
                  );
                },
                icon: const Icon(
                  Icons.logout_rounded,
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.charcoal,
                  side: const BorderSide(
                    color: AppTheme.softGray,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// SECTION TITLE
// ==========================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: AppTheme.charcoal,
      ),
    );
  }
}

// ==========================================================================
// ARTIST APPLICATION CARD
// ==========================================================================

class _ArtistApplicationCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const _ArtistApplicationCard({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------
    // PENDING
    // ------------------------------------------------------------

    if (user.artistApplicationPending) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    AppTheme.oliveGreen.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.hourglass_top_outlined,
                color: AppTheme.oliveGreen,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Pending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Your artist application is being reviewed.',
                    style: TextStyle(
                      color: AppTheme.softGray,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ------------------------------------------------------------
    // REJECTED
    // ------------------------------------------------------------

    if (user.artistApplicationRejected) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.red,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Rejected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'You can submit a new application.',
                    style: TextStyle(
                      color: AppTheme.softGray,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: onTap,
                    child: const Text(
                      'Apply Again',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ------------------------------------------------------------
    // CAN APPLY
    // ------------------------------------------------------------

    if (user.canApplyAsArtist) {
      return _ProfileActionCard(
        icon: Icons.brush_outlined,
        title: 'Apply to Become an Artist',
        subtitle:
            'Completed your course? Start selling your art.',
        onTap: onTap,
      );
    }

    // ------------------------------------------------------------
    // NOT ELIGIBLE YET
    // ------------------------------------------------------------

    return _ProfileActionCard(
      icon: Icons.brush_outlined,
      title: 'Become an Artist',
      subtitle:
          'Complete at least one course to apply.',
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Complete at least one course before applying.',
            ),
          ),
        );
      },
    );
  }
}

// ==========================================================================
// PROFILE ACTION CARD
// ==========================================================================

class _ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      AppTheme.oliveGreen.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
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
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppTheme.charcoal,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.softGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: AppTheme.softGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}