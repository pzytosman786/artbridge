import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../theme/app_theme.dart';

class ArtistApplicationScreen extends StatefulWidget {
  const ArtistApplicationScreen({super.key});

  @override
  State<ArtistApplicationScreen> createState() =>
      _ArtistApplicationScreenState();
}

class _ArtistApplicationScreenState
    extends State<ArtistApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final bioController = TextEditingController();
  final specializationController = TextEditingController();
  final portfolioController = TextEditingController();

  @override
  void dispose() {
    bioController.dispose();
    specializationController.dispose();
    portfolioController.dispose();
    super.dispose();
  }

  void submitApplication() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appState = context.read<AppState>();

    if (!appState.currentUser!.canApplyAsArtist) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are not eligible to apply as an artist yet.',
          ),
        ),
      );
      return;
    }

    appState.applyToBecomeArtist(
      bio: bioController.text.trim(),
      specialization: specializationController.text.trim(),
      portfolio: portfolioController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Your artist application has been submitted.',
        ),
      ),
    );

    Navigator.pop(context);
  }

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

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: const Text('Become an Artist'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.oliveGreen.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 38,
                    color: AppTheme.oliveGreen,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Share your creativity with ArtBridge',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.charcoal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tell us about yourself and your artwork. '
                    'Your application will be reviewed by the ArtBridge admin.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.softGray,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Artist Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: bioController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'About You',
                hintText:
                    'Tell us about yourself and your artistic journey...',
                prefixIcon: Icon(Icons.person_outline),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please tell us about yourself.';
                }

                if (value.trim().length < 20) {
                  return 'Please write at least 20 characters.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: specializationController,
              decoration: const InputDecoration(
                labelText: 'Art Specialization',
                hintText:
                    'e.g. Painting, Digital Art, Pencil Drawing',
                prefixIcon: Icon(Icons.brush_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your specialization.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: portfolioController,
              decoration: const InputDecoration(
                labelText: 'Portfolio',
                hintText:
                    'Enter your portfolio link or describe your previous work',
                prefixIcon: Icon(Icons.link),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide your portfolio.';
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.oliveGreen,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'After approval, you will become an ArtBridge Artist '
                      'using this same account. You will then be able to '
                      'upload your artwork and sell it on the marketplace.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.softGray,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: submitApplication,
              child: const Text('Submit Artist Application'),
            ),
          ],
        ),
      ),
    );
  }
}