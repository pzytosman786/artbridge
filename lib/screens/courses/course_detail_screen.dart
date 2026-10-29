import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in again.'),
        ),
      );
    }

    final enrollmentInfo = _getEnrollmentInfo(
      appState,
      user.id,
      course.id,
    );

    final isEnrolled = enrollmentInfo.isEnrolled;
    final isCompleted = enrollmentInfo.isCompleted;
    final progress = enrollmentInfo.progress;

    final bool isPhysical = course.type == CourseType.physical;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,

      // ================================================================
      // APP BAR
      // ================================================================

      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: AppTheme.warmCream,
        foregroundColor: AppTheme.charcoal,
        elevation: 0,
      ),

      // ================================================================
      // BODY
      // ================================================================

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          30,
        ),
        children: [
          // ============================================================
          // COURSE IMAGE
          // ============================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.asset(
                course.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: AppTheme.oliveGreen.withValues(
                      alpha: 0.10,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppTheme.oliveGreen,
                        size: 70,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ============================================================
          // COURSE TYPE BADGE
          // ============================================================

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: AppTheme.oliveGreen.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isPhysical ? 'PHYSICAL CLASS' : 'ART BOOK',
                style: const TextStyle(
                  color: AppTheme.oliveGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ============================================================
          // COURSE TITLE
          // ============================================================

          Text(
            course.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                  color: AppTheme.charcoal,
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 10),

          // ============================================================
          // DESCRIPTION
          // ============================================================

          Text(
            course.description,
            style: const TextStyle(
              color: AppTheme.softGray,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // ============================================================
          // COURSE INFORMATION
          // ============================================================

          Container(
            padding: const EdgeInsets.all(18),
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
              children: [
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Instructor',
                  value: course.instructor,
                ),

                const Divider(height: 24),

                _InfoRow(
                  icon: Icons.schedule_outlined,
                  label: 'Duration',
                  value: course.duration,
                ),

                const Divider(height: 24),

                _InfoRow(
                  icon: Icons.category_outlined,
                  label: 'Course Type',
                  value: _courseTypeName(course.type),
                ),

                const Divider(height: 24),

                _InfoRow(
                  icon: Icons.payments_outlined,
                  label: 'Price',
                  value:
                      'RM ${course.price.toStringAsFixed(0)}',
                ),
              ],
            ),
          ),

          // ============================================================
          // COURSE PROGRESS
          // ============================================================

          if (isEnrolled) ...[
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
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
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.charcoal,
                    ),
                  ),

                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8,
                      backgroundColor:
                          AppTheme.oliveGreen.withValues(
                        alpha: 0.12,
                      ),
                      color: AppTheme.oliveGreen,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${progress.toStringAsFixed(0)}% completed',
                    style: const TextStyle(
                      color: AppTheme.softGray,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ============================================================
          // ACTION BUTTON
          // ============================================================

          const SizedBox(height: 24),

          if (!isEnrolled)

            // ----------------------------------------------------------
            // ENROLL BUTTON
            // ----------------------------------------------------------

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final success =
                      await appState.enrollInCourse(
                    course.id,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'You have successfully enrolled in this course.'
                            : 'Failed to enroll. Please try again.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.school_outlined,
                ),
                label: Text(
                  'Enroll for RM ${course.price.toStringAsFixed(0)}',
                ),
              ),
            )

          else if (!isCompleted)

            // ----------------------------------------------------------
            // COMPLETE BUTTON
            // ----------------------------------------------------------

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final success =
                      await appState.completeCourse(
                    course.id,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Course completed! You are now eligible to apply as an Artist.'
                            : 'Failed to complete course. Please try again.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                ),
                label: const Text(
                  'Complete Course',
                ),
              ),
            )

          else

            // ----------------------------------------------------------
            // COMPLETED MESSAGE
            // ----------------------------------------------------------

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.oliveGreen.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.oliveGreen,
                    size: 28,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Course completed! You can now apply to become an Artist from your Profile.',
                      style: TextStyle(
                        color: AppTheme.darkOlive,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ========================================================================
  // COURSE TYPE
  // ========================================================================

  String _courseTypeName(CourseType type) {
    switch (type) {
      case CourseType.online:
        return 'Online Course';

      case CourseType.video:
        return 'Video Course';

      case CourseType.pdf:
        return 'Art Book';

      case CourseType.physical:
        return 'Physical Class';
    }
  }

  // ========================================================================
  // FIND ENROLLMENT
  // ========================================================================

  EnrollmentInfo _getEnrollmentInfo(
    AppState appState,
    String userId,
    String courseId,
  ) {
    for (final enrollment in appState.enrollments) {
      if (enrollment.userId == userId &&
          enrollment.courseId == courseId) {
        return EnrollmentInfo(
          isEnrolled: true,
          isCompleted: enrollment.isCompleted,
          progress: enrollment.progress,
        );
      }
    }

    return EnrollmentInfo(
      isEnrolled: false,
      isCompleted: false,
      progress: 0,
    );
  }
}

// ============================================================================
// ENROLLMENT INFO
// ============================================================================

class EnrollmentInfo {
  final bool isEnrolled;
  final bool isCompleted;
  final double progress;

  const EnrollmentInfo({
    required this.isEnrolled,
    required this.isCompleted,
    required this.progress,
  });
}

// ============================================================================
// INFORMATION ROW
// ============================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.oliveGreen.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.oliveGreen,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.softGray,
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppTheme.charcoal,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}