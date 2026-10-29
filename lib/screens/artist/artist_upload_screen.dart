import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';

class ArtistUploadScreen extends StatefulWidget {
  const ArtistUploadScreen({super.key});

  @override
  State<ArtistUploadScreen> createState() => _ArtistUploadScreenState();
}

class _ArtistUploadScreenState extends State<ArtistUploadScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;

  String _selectedCategory = 'Painting';
  bool _isUploading = false;

  // ============================================================
  // CLOUDINARY
  // ============================================================

  static const String _cloudName = 'xa8qsf1i';
  static const String _uploadPreset = 'artbridge_images';

  final List<String> _categories = [
    'Painting',
    'Drawing',
    'Digital Art',
    'Photography',
    'Craft',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // ============================================================
  // SELECT IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = image;
      });
    } catch (e) {
      _showMessage(
        'Could not select the image. Please try again.',
      );
    }
  }

  // ============================================================
  // REMOVE IMAGE
  // ============================================================

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // ============================================================
  // UPLOAD IMAGE TO CLOUDINARY
  // ============================================================

  Future<String?> _uploadImageToCloudinary() async {
    if (_selectedImage == null) {
      return null;
    }

    try {
      final imageBytes = await _selectedImage!.readAsBytes();

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/'
        '$_cloudName/image/upload',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['upload_preset'] = _uploadPreset;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: _selectedImage!.name,
        ),
      );

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        return data['secure_url']?.toString();
      }

      debugPrint(
        'Cloudinary upload failed: '
        '${response.statusCode}',
      );

      debugPrint(responseBody);

      return null;
    } catch (e) {
      debugPrint(
        'Cloudinary upload error: $e',
      );

      return null;
    }
  }

  // ============================================================
  // UPLOAD ARTWORK
  // ============================================================

  Future<void> _uploadArtwork() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      _showMessage(
        'Please select an artwork image.',
      );
      return;
    }

    final appState = context.read<AppState>();

    if (appState.currentUser == null) {
      _showMessage(
        'Please log in again.',
      );
      return;
    }

    if (!appState.currentUser!.isArtist) {
      _showMessage(
        'Only approved artists can upload artwork.',
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // ----------------------------------------------------------
      // 1. Upload image to Cloudinary
      // ----------------------------------------------------------

      final imageUrl =
          await _uploadImageToCloudinary();

      if (!mounted) return;

      if (imageUrl == null || imageUrl.isEmpty) {
        _showMessage(
          'Image upload failed. Please try again.',
        );
        return;
      }

      // ----------------------------------------------------------
      // 2. Save artwork information to Firestore
      // ----------------------------------------------------------

      final success = await appState.submitArtwork(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(
          _priceController.text.trim(),
        ),
        category: _selectedCategory,
        image: imageUrl,
      );

      if (!mounted) return;

      if (success) {
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();

        setState(() {
          _selectedImage = null;
          _selectedCategory = 'Painting';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Artwork uploaded successfully!',
            ),
          ),
        );

        Navigator.pop(context);
      } else {
        _showMessage(
          'Artwork information could not be saved. '
          'Please try again.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint(
        'Artwork upload error: $e',
      );

      _showMessage(
        'Something went wrong while uploading.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please log in again.',
          ),
        ),
      );
    }

    if (!user.isArtist) {
      return Scaffold(
        backgroundColor: AppTheme.warmCream,
        appBar: AppBar(
          title: const Text(
            'Upload Artwork',
          ),
          backgroundColor: AppTheme.warmCream,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Only approved artists can upload artwork.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: const Text(
          'Upload Artwork',
        ),
        backgroundColor: AppTheme.warmCream,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ======================================================
            // LOGO
            // ======================================================

            const Center(
              child: BrandLogo(
                width: 145,
                height: 60,
              ),
            ),

            const SizedBox(height: 10),

            // ======================================================
            // HEADER
            // ======================================================

            const Text(
              'Share Your Artwork',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Upload your artwork and make it available '
              'in the ArtBridge marketplace.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppTheme.softGray,
              ),
            ),

            const SizedBox(height: 28),

            // ======================================================
            // IMAGE
            // ======================================================

            _buildLabel('Artwork Image'),

            const SizedBox(height: 8),

            _buildImagePicker(),

            const SizedBox(height: 24),

            // ======================================================
            // TITLE
            // ======================================================

            _buildLabel('Artwork Title'),

            const SizedBox(height: 8),

            TextFormField(
              controller: _titleController,
              textCapitalization:
                  TextCapitalization.words,
              decoration: InputDecoration(
                hintText:
                    'Example: Sunset Over the Hills',
                prefixIcon: const Icon(
                  Icons.title,
                  color: AppTheme.oliveGreen,
                ),
                filled: true,
                fillColor: AppTheme.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter an artwork title';
                }

                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // ======================================================
            // DESCRIPTION
            // ======================================================

            _buildLabel('Description'),

            const SizedBox(height: 8),

            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              textCapitalization:
                  TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    'Tell buyers about your artwork...',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(
                    bottom: 70,
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppTheme.oliveGreen,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter a description';
                }

                if (value.trim().length < 10) {
                  return 'Description must be at least 10 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // ======================================================
            // PRICE
            // ======================================================

            _buildLabel('Price (RM)'),

            const SizedBox(height: 8),

            TextFormField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Example: 50',
                prefixIcon: const Icon(
                  Icons.payments_outlined,
                  color: AppTheme.oliveGreen,
                ),
                prefixText: 'RM ',
                filled: true,
                fillColor: AppTheme.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter a price';
                }

                final price =
                    double.tryParse(
                  value.trim(),
                );

                if (price == null) {
                  return 'Please enter a valid price';
                }

                if (price <= 0) {
                  return 'Price must be greater than RM 0';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // ======================================================
            // CATEGORY
            // ======================================================

            _buildLabel('Category'),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.category_outlined,
                  color: AppTheme.oliveGreen,
                ),
                filled: true,
                fillColor: AppTheme.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _categories.map(
                (category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // ======================================================
            // UPLOAD BUTTON
            // ======================================================

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed:
                    _isUploading
                        ? null
                        : _uploadArtwork,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.oliveGreen,
                  foregroundColor:
                      AppTheme.white,
                  disabledBackgroundColor:
                      AppTheme.oliveGreen
                          .withValues(alpha: 0.5),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color:
                                  AppTheme.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Uploading...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Upload Artwork',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // ======================================================
            // INFO
            // ======================================================

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.oliveGreen
                    .withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.oliveGreen,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'As an approved ArtBridge artist, '
                      'your artwork will be published '
                      'directly to the marketplace without '
                      'additional admin approval.',
                      style: TextStyle(
                        color: AppTheme.softGray,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE PICKER UI
  // ============================================================

  Widget _buildImagePicker() {
    if (_selectedImage == null) {
      return InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 230,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius:
                BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.oliveGreen
                  .withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 54,
                color: AppTheme.oliveGreen,
              ),
              SizedBox(height: 12),
              Text(
                'Select Artwork Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.charcoal,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Choose an image from your gallery',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.softGray,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(16),
          child: FutureBuilder<List<int>>(
            future: _selectedImage!.readAsBytes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 230,
                  width: double.infinity,
                  color: AppTheme.white,
                  child: const Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                );
              }

              return Image.memory(
                Uint8List.fromList(
                  snapshot.data!,
                ),
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    _isUploading
                        ? null
                        : _pickImage,
                icon: const Icon(
                  Icons.change_circle_outlined,
                ),
                label: const Text(
                  'Change Image',
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      AppTheme.oliveGreen,
                  side: const BorderSide(
                    color:
                        AppTheme.oliveGreen,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed:
                  _isUploading
                      ? null
                      : _removeImage,
              tooltip: 'Remove image',
              icon: const Icon(
                Icons.delete_outline,
                color: AppTheme.softGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTheme.charcoal,
      ),
    );
  }
}