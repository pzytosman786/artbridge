import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/artwork.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';

class ArtworkDetailScreen extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailScreen({
    super.key,
    required this.artwork,
  });

  // ==========================================================================
  // CHECK IF CURRENT USER OWNS THE ARTWORK
  // ==========================================================================

  bool _isOwnArtwork(AppState appState) {
    final currentUser = appState.currentUser;

    if (currentUser == null) {
      return false;
    }

    return currentUser.id == artwork.artistId;
  }

  // ==========================================================================
  // CHECKOUT
  // ==========================================================================

  void _showCheckout(BuildContext context) {
    final appState = context.read<AppState>();

    if (appState.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please log in before purchasing artwork.',
          ),
        ),
      );

      return;
    }

    if (_isOwnArtwork(appState)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You cannot purchase your own artwork.',
          ),
        ),
      );

      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return _CheckoutSheet(
          artwork: artwork,
        );
      },
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final isOwnArtwork =
        _isOwnArtwork(appState);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ==================================================================
            // APP BAR
            // ==================================================================

            SliverAppBar(
              backgroundColor:
                  AppTheme.warmCream,
              surfaceTintColor:
                  Colors.transparent,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.charcoal,
                ),
              ),
              title: const BrandLogo(
                width: 110,
                height: 48,
              ),
              centerTitle: true,
            ),

            // ==================================================================
            // CONTENT
            // ==================================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // ==========================================================
                    // ARTWORK IMAGE
                    // ==========================================================

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(22),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: artwork.image.isNotEmpty
                            ? Image.network(
                                artwork.image,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Container(
                                    color: AppTheme
                                        .oliveGreen
                                        .withValues(
                                      alpha: 0.12,
                                    ),
                                    child:
                                        const Icon(
                                      Icons
                                          .broken_image_outlined,
                                      size: 70,
                                      color: AppTheme
                                          .oliveGreen,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (
                                  context,
                                  child,
                                  progress,
                                ) {
                                  if (progress ==
                                      null) {
                                    return child;
                                  }

                                  return Container(
                                    color: AppTheme
                                        .oliveGreen
                                        .withValues(
                                      alpha: 0.08,
                                    ),
                                    child:
                                        const Center(
                                      child:
                                          CircularProgressIndicator(
                                        color: AppTheme
                                            .oliveGreen,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppTheme
                                    .oliveGreen
                                    .withValues(
                                  alpha: 0.12,
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 70,
                                  color: AppTheme
                                      .oliveGreen,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==========================================================
                    // CATEGORY
                    // ==========================================================

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration:
                          BoxDecoration(
                        color: AppTheme
                            .oliveGreen
                            .withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        artwork.category,
                        style:
                            const TextStyle(
                          color: AppTheme
                              .oliveGreen,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==========================================================
                    // TITLE
                    // ==========================================================

                    Text(
                      artwork.title,
                      style: const TextStyle(
                        color:
                            AppTheme.charcoal,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ==========================================================
                    // ARTIST
                    // ==========================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        14,
                      ),
                      decoration:
                          BoxDecoration(
                        color: AppTheme.white,
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration:
                                BoxDecoration(
                              color: AppTheme
                                  .oliveGreen
                                  .withValues(
                                alpha: 0.12,
                              ),
                              shape:
                                  BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons
                                  .person_outline,
                              color: AppTheme
                                  .oliveGreen,
                              size: 23,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  'Created by',
                                  style:
                                      TextStyle(
                                    color: AppTheme
                                        .softGray,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  artwork.artistName,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      const TextStyle(
                                    color: AppTheme
                                        .charcoal,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (isOwnArtwork)
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: AppTheme
                                    .oliveGreen
                                    .withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  10,
                                ),
                              ),
                              child: const Text(
                                'You',
                                style: TextStyle(
                                  color: AppTheme
                                      .oliveGreen,
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==========================================================
                    // DESCRIPTION
                    // ==========================================================

                    const Text(
                      'About this artwork',
                      style: TextStyle(
                        color:
                            AppTheme.charcoal,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      artwork.description.isEmpty
                          ? 'No description provided.'
                          : artwork.description,
                      style: const TextStyle(
                        color:
                            AppTheme.softGray,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==========================================================
                    // PRICE
                    // ==========================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        18,
                      ),
                      decoration:
                          BoxDecoration(
                        color: AppTheme.white,
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              color: AppTheme
                                  .softGray,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'RM ${artwork.price.toStringAsFixed(2)}',
                            style:
                                const TextStyle(
                              color: AppTheme
                                  .oliveGreen,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================================================
                    // BUY BUTTON / OWN ARTWORK
                    // ==========================================================

                    if (isOwnArtwork)
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        decoration:
                            BoxDecoration(
                          color: AppTheme
                              .oliveGreen
                              .withValues(
                            alpha: 0.08,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: AppTheme
                                .oliveGreen
                                .withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons
                                  .palette_outlined,
                              color: AppTheme
                                  .oliveGreen,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'Your Artwork',
                                    style:
                                        TextStyle(
                                      color: AppTheme
                                          .charcoal,
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'You cannot purchase your own artwork.',
                                    style:
                                        TextStyle(
                                      color: AppTheme
                                          .softGray,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child:
                            ElevatedButton.icon(
                          onPressed: () {
                            _showCheckout(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons
                                .shopping_bag_outlined,
                          ),
                          label: const Text(
                            'Buy Artwork',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    const Center(
                      child: Text(
                        'Demo checkout • No real payment is processed',
                        style: TextStyle(
                          color:
                              AppTheme.softGray,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
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
// CHECKOUT SHEET
// ============================================================================

class _CheckoutSheet extends StatelessWidget {
  final Artwork artwork;

  const _CheckoutSheet({
    required this.artwork,
  });

  Future<void> _completePurchase(
    BuildContext context,
  ) async {
    final appState =
        context.read<AppState>();

    final success =
        await appState.buyArtwork(
      artwork.id,
    );

    if (!context.mounted) return;

    Navigator.pop(context);

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Purchase could not be completed.',
          ),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              AppTheme.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration:
                    BoxDecoration(
                  color: AppTheme
                      .oliveGreen
                      .withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 34,
                  color:
                      AppTheme.oliveGreen,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Purchase Successful!',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      AppTheme.charcoal,
                  fontSize: 21,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '${artwork.title} has been added to your orders.',
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color:
                      AppTheme.softGray,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ================================================================
            // HANDLE
            // ================================================================

            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration:
                    BoxDecoration(
                  color: AppTheme
                      .softGray
                      .withValues(
                    alpha: 0.25,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Confirm Purchase',
              style: TextStyle(
                color:
                    AppTheme.charcoal,
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ================================================================
            // ARTWORK SUMMARY
            // ================================================================

            Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: artwork
                            .image
                            .isNotEmpty
                        ? Image.network(
                            artwork.image,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return
                                  const _SmallImagePlaceholder();
                            },
                          )
                        : const _SmallImagePlaceholder(),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        artwork.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color: AppTheme
                              .charcoal,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        artwork.artistName,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color: AppTheme
                              .softGray,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        artwork.category,
                        style:
                            const TextStyle(
                          color: AppTheme
                              .softGray,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        'RM ${artwork.price.toStringAsFixed(2)}',
                        style:
                            const TextStyle(
                          color: AppTheme
                              .oliveGreen,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================================================================
            // PAYMENT INFORMATION
            // ================================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                15,
              ),
              decoration:
                  BoxDecoration(
                color: AppTheme
                    .oliveGreen
                    .withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme
                        .oliveGreen,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is a demonstration checkout. No real payment will be charged.',
                      style: TextStyle(
                        color: AppTheme
                            .softGray,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ================================================================
            // TOTAL
            // ================================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color:
                        AppTheme.charcoal,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                Text(
                  'RM ${artwork.price.toStringAsFixed(2)}',
                  style:
                      const TextStyle(
                    color: AppTheme
                        .oliveGreen,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================================================================
            // CONFIRM BUTTON
            // ================================================================

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  _completePurchase(
                    context,
                  );
                },
                child: const Text(
                  'Confirm Purchase',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
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
// SMALL IMAGE PLACEHOLDER
// ============================================================================

class _SmallImagePlaceholder
    extends StatelessWidget {
  const _SmallImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.oliveGreen
          .withValues(alpha: 0.12),
      child: const Icon(
        Icons.image_outlined,
        color: AppTheme.oliveGreen,
      ),
    );
  }
}