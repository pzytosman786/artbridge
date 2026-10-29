import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/artist_application.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';

class ArtistApplicationsScreen extends StatelessWidget {
  const ArtistApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final applications = appState.artistApplications;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        backgroundColor: AppTheme.warmCream,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppTheme.charcoal,
        ),
        title: const Text(
          'Artist Applications',
          style: TextStyle(
            color: AppTheme.charcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
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
            // INTRODUCTION
            // ============================================================

            const Text(
              'Review Artist Applications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Review applications and approve eligible users to become ArtBridge artists.',
              style: TextStyle(
                color: AppTheme.softGray,
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // APPLICATION COUNT
            // ============================================================

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppTheme.oliveGreen.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.people_alt_outlined,
                      color: AppTheme.oliveGreen,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Applications',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.softGray,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${applications.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.charcoal,
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
            // APPLICATION LIST
            // ============================================================

            if (applications.isEmpty)
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: AppTheme.softGray,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No artist applications yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.charcoal,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'New applications will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.softGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...applications.map(
                (application) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ApplicationCard(
                    application: application,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// APPLICATION CARD
// ==========================================================================

class _ApplicationCard extends StatelessWidget {
  final ArtistApplication application;

  const _ApplicationCard({
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================================================================
          // HEADER
          // ================================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.oliveGreen.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppTheme.oliveGreen,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Artist Applicant',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'User ID: ${application.userId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.softGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusBadge(
                status: application.status,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ================================================================
          // SPECIALIZATION
          // ================================================================

          const Text(
            'Specialization',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            application.specialization,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.charcoal,
            ),
          ),

          const SizedBox(height: 14),

          // ================================================================
          // BIO
          // ================================================================

          const Text(
            'About the Artist',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            application.bio,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.charcoal,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          // ================================================================
          // PORTFOLIO
          // ================================================================

          const Text(
            'Portfolio',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            application.portfolio.isEmpty
                ? 'No portfolio provided.'
                : application.portfolio,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.charcoal,
            ),
          ),

          // ================================================================
          // ACTIONS
          // ================================================================

          if (application.status == ApplicationStatus.pending) ...[
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final confirmed = await _showRejectDialog(
                        context,
                      );

                      if (!confirmed) return;

                      await appState.rejectArtistApplication(
                        application.id,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Artist application rejected.',
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.charcoal,
                      side: const BorderSide(
                        color: AppTheme.softGray,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await appState.approveArtistApplication(
                        application.id,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Artist application approved.',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.oliveGreen,
                      foregroundColor: AppTheme.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Approve',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<bool> _showRejectDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Reject Application?',
          ),
          content: const Text(
            'Are you sure you want to reject this artist application?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.oliveGreen,
                foregroundColor: AppTheme.white,
              ),
              child: const Text(
                'Reject',
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}

// ==========================================================================
// STATUS BADGE
// ==========================================================================

class _StatusBadge extends StatelessWidget {
  final ApplicationStatus status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String text;

    switch (status) {
      case ApplicationStatus.pending:
        text = 'Pending';
        break;

      case ApplicationStatus.approved:
        text = 'Approved';
        break;

      case ApplicationStatus.rejected:
        text = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.oliveGreen.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.oliveGreen,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}