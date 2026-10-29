import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final artBooks = appState.courses
        .where((course) => course.type == CourseType.pdf)
        .toList();

    final physicalClasses = appState.courses
        .where((course) => course.type == CourseType.physical)
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            // ============================================================
            // HEADER
            // ============================================================

            Text(
              'Learn',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.charcoal,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Learn new artistic skills and discover your creativity.',
              style: TextStyle(
                color: AppTheme.softGray,
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            // ============================================================
            // ART BOOKS SECTION
            // ============================================================

            const _SectionHeader(
              title: 'ART BOOKS',
              subtitle: 'Learn at your own pace',
              icon: Icons.menu_book_outlined,
            ),

            const SizedBox(height: 14),

            ...artBooks.map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CourseCard(
                  course: course,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(
                          course: course,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ============================================================
            // SPACE BETWEEN SECTIONS
            // ============================================================

            const SizedBox(height: 12),

            // ============================================================
            // PHYSICAL CLASSES SECTION
            // ============================================================

            const _SectionHeader(
              title: 'PHYSICAL CLASSES',
              subtitle: 'Learn through hands-on practice',
              icon: Icons.palette_outlined,
            ),

            const SizedBox(height: 14),

            ...physicalClasses.map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CourseCard(
                  course: course,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(
                          course: course,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.oliveGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: AppTheme.oliveGreen,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.charcoal,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.softGray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// COURSE CARD
// ============================================================================

class _CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhysical = course.type == CourseType.physical;

    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.oliveGreen.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // COURSE IMAGE
              // ==========================================================

              AspectRatio(
                aspectRatio: 4 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      // IMPORTANT:
                      // Each course uses its own image path
                      // from AppState.
                      course.image,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: AppTheme.oliveGreen.withValues(
                            alpha: 0.08,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppTheme.oliveGreen,
                              size: 42,
                            ),
                          ),
                        );
                      },
                    ),

                    // ------------------------------------------------------
                    // SUBTLE IMAGE GRADIENT
                    // ------------------------------------------------------

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 70,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ------------------------------------------------------
                    // COURSE TYPE BADGE
                    // ------------------------------------------------------

                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isPhysical
                              ? 'PHYSICAL CLASS'
                              : 'ART BOOK',
                          style: const TextStyle(
                            color: AppTheme.charcoal,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================================
              // COURSE INFORMATION
              // ==========================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  15,
                  16,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------------------------------------
                    // TITLE
                    // ------------------------------------------------------

                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.charcoal,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ------------------------------------------------------
                    // TYPE
                    // ------------------------------------------------------

                    Text(
                      isPhysical
                          ? 'Hands-on learning'
                          : 'Learn at your own pace',
                      style: const TextStyle(
                        color: AppTheme.softGray,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 13),

                    // ------------------------------------------------------
                    // PRICE + ARROW
                    // ------------------------------------------------------

                    Row(
                      children: [
                        Text(
                          'RM ${course.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppTheme.oliveGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppTheme.oliveGreen.withValues(
                              alpha: 0.10,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                            color: AppTheme.oliveGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}