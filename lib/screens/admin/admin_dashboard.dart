import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';
import 'artist_applications_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final totalUsers = appState.users.length;

    final totalArtists = appState.users
        .where((user) => user.isArtist)
        .length;

    final pendingApplications = appState.artistApplications
        .where(
          (application) => application.status.name == 'pending',
        )
        .length;

    final totalArtworks = appState.artworks.length;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,

      // ================================================================
      // APP BAR
      // ================================================================

      appBar: AppBar(
        backgroundColor: AppTheme.warmCream,
        foregroundColor: AppTheme.charcoal,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================================================================
      // BODY
      // ================================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // BRAND LOGO
            // ============================================================

            const Center(
              child: BrandLogo(
                width: 145,
                height: 60,
              ),
            ),

            const SizedBox(height: 10),

            // ============================================================
            // HEADER
            // ============================================================

            const Text(
              'Welcome, Admin 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage ArtBridge users, artists and applications.',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.softGray,
              ),
            ),

            const SizedBox(height: 28),

            // ============================================================
            // OVERVIEW
            // ============================================================

            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),

            const SizedBox(height: 14),

            // ============================================================
            // STATISTICS
            // ============================================================

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              // Keep the mobile layout that was already working.
              childAspectRatio: 1.30,

              children: [
                _StatCard(
                  title: 'Users',
                  value: totalUsers.toString(),
                  icon: Icons.people_outline,
                ),

                _StatCard(
                  title: 'Artists',
                  value: totalArtists.toString(),
                  icon: Icons.palette_outlined,
                ),

                _StatCard(
                  title: 'Applications',
                  value: pendingApplications.toString(),
                  icon: Icons.assignment_outlined,
                ),

                _StatCard(
                  title: 'Artworks',
                  value: totalArtworks.toString(),
                  icon: Icons.image_outlined,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ============================================================
            // ADMIN CONTROLS
            // ============================================================

            const Text(
              'Admin Controls',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),

            const SizedBox(height: 14),

            // ============================================================
            // ARTIST APPLICATIONS
            // ============================================================

            _AdminOption(
              icon: Icons.assignment_ind_outlined,
              title: 'Artist Applications',
              subtitle: pendingApplications > 0
                  ? '$pendingApplications application(s) waiting for review'
                  : 'Review artist applications',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ArtistApplicationsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ============================================================
            // MANAGE USERS
            // ============================================================

            _AdminOption(
              icon: Icons.manage_accounts_outlined,
              title: 'Manage Users',
              subtitle: 'View and manage registered users',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'User management will be added next.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ============================================================
            // MANAGE ARTWORKS
            // ============================================================

            _AdminOption(
              icon: Icons.collections_outlined,
              title: 'Manage Artworks',
              subtitle: 'View artworks uploaded by artists',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Artwork management will be added later.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ============================================================
            // LOGOUT
            // ============================================================

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AppState>().logout();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'Logout',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.darkOlive,
                  side: const BorderSide(
                    color: AppTheme.darkOlive,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
// STAT CARD
// ==========================================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.oliveGreen.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppTheme.darkOlive,
            size: 28,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.softGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// ADMIN OPTION
// ==========================================================================

class _AdminOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminOption({
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
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // ==========================================================
              // ICON
              // ==========================================================

              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.oliveGreen.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.darkOlive,
                  size: 26,
                ),
              ),

              const SizedBox(width: 15),

              // ==========================================================
              // TEXT
              // ==========================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.charcoal,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.softGray,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right,
                color: AppTheme.softGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}