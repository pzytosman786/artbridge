import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/artwork.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';
import 'artwork_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Painting',
    'Digital',
    'Drawing',
    'Photography',
    'Craft',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadArtworks();
    });
  }

  // ============================================================================
  // FILTER ARTWORKS
  // ============================================================================

  List<Artwork> _filteredArtworks(List<Artwork> artworks) {
    return artworks.where((artwork) {
      final categoryMatches =
          _selectedCategory == 'All' ||
          artwork.category.toLowerCase() ==
              _selectedCategory.toLowerCase();

      final searchText = _searchQuery.toLowerCase();

      final searchMatches =
          _searchQuery.isEmpty ||
          artwork.title.toLowerCase().contains(searchText) ||
          artwork.description.toLowerCase().contains(searchText) ||
          artwork.category.toLowerCase().contains(searchText) ||
          artwork.artistName.toLowerCase().contains(searchText);

      return categoryMatches && searchMatches;
    }).toList();
  }

  // ============================================================================
  // SEARCH DIALOG
  // ============================================================================

  void _showSearchDialog() {
    final controller = TextEditingController(
      text: _searchQuery,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Search Artwork',
            style: TextStyle(
              color: AppTheme.charcoal,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search artwork or artist...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) {
              setState(() {
                _searchQuery = controller.text.trim();
              });

              Navigator.pop(dialogContext);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });

                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: AppTheme.softGray,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = controller.text.trim();
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================================
  // OPEN ARTWORK DETAILS
  // ============================================================================

  void _openArtworkDetails(
    BuildContext context,
    Artwork artwork,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ArtworkDetailScreen(
            artwork: artwork,
          );
        },
      ),
    );
  }

  // ============================================================================
  // BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final artworks = _filteredArtworks(
      appState.artworks,
    );

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.oliveGreen,
          onRefresh: appState.loadArtworks,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              // ==================================================================
              // BRAND LOGO
              // ==================================================================

              const BrandLogo(
                width: 145,
                height: 60,
              ),

              const SizedBox(height: 4),

              // ==================================================================
              // HEADER
              // ==================================================================

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Marketplace',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: AppTheme.charcoal,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showSearchDialog,
                    icon: const Icon(
                      Icons.search,
                      color: AppTheme.charcoal,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Discover and support creative artists.',
                style: TextStyle(
                  color: AppTheme.softGray,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================================
              // SEARCH RESULT INDICATOR
              // ==================================================================

              if (_searchQuery.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.oliveGreen.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        size: 18,
                        color: AppTheme.oliveGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Searching for "$_searchQuery"',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.charcoal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppTheme.softGray,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

              // ==================================================================
              // CATEGORY FILTERS
              // ==================================================================

              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];

                    return _CategoryChip(
                      label: category,
                      selected:
                          _selectedCategory == category,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================================
              // SECTION TITLE
              // ==================================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Artwork',
                    style: TextStyle(
                      color: AppTheme.charcoal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${artworks.length} item${artworks.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: AppTheme.softGray,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ==================================================================
              // ARTWORK GRID
              // ==================================================================

              if (appState.artworks.isEmpty)
                const _EmptyMarketplace()
              else if (artworks.isEmpty)
                const _NoSearchResults()
              else
                GridView.builder(
                  itemCount: artworks.length,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,

                    // IMPORTANT:
                    // Use a fixed height instead of childAspectRatio.
                    // This prevents the artwork card from overflowing.
                    mainAxisExtent: 300,
                  ),
                  itemBuilder: (context, index) {
                    final artwork = artworks[index];

                    return _ArtworkCard(
                      artwork: artwork,
                      onTap: () {
                        _openArtworkDetails(
                          context,
                          artwork,
                        );
                      },
                    );
                  },
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
// CATEGORY CHIP
// ============================================================================

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label),
          backgroundColor:
              selected
                  ? AppTheme.oliveGreen
                  : AppTheme.white,
          side: BorderSide.none,
          labelStyle: TextStyle(
            color:
                selected
                    ? AppTheme.white
                    : AppTheme.charcoal,
            fontWeight:
                selected
                    ? FontWeight.w600
                    : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ARTWORK CARD
// ============================================================================

class _ArtworkCard extends StatelessWidget {
  final Artwork artwork;
  final VoidCallback onTap;

  const _ArtworkCard({
    required this.artwork,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================================
          // IMAGE
          // ==================================================================

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child:
                  artwork.image.isNotEmpty
                      ? Image.network(
                        artwork.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const _ImagePlaceholder();
                        },
                        loadingBuilder: (
                          context,
                          child,
                          progress,
                        ) {
                          if (progress == null) {
                            return child;
                          }

                          return Container(
                            width: double.infinity,
                            color: AppTheme.oliveGreen
                                .withValues(
                              alpha: 0.08,
                            ),
                            child: const Center(
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    AppTheme.oliveGreen,
                              ),
                            ),
                          );
                        },
                      )
                      : const _ImagePlaceholder(),
            ),
          ),

          // ==================================================================
          // INFORMATION
          // ==================================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              11,
              9,
              11,
              9,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ARTWORK TITLE
                Text(
                  artwork.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                // ARTIST NAME
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 15,
                      color: AppTheme.oliveGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        artwork.artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.charcoal,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // CATEGORY
                Text(
                  artwork.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.softGray,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                // PRICE + VIEW DETAILS
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'RM ${artwork.price.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.oliveGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    InkWell(
                      onTap: onTap,
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.oliveGreen,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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
// IMAGE PLACEHOLDER
// ============================================================================

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.oliveGreen.withValues(
        alpha: 0.12,
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 55,
          color: AppTheme.oliveGreen,
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY MARKETPLACE
// ============================================================================

class _EmptyMarketplace extends StatelessWidget {
  const _EmptyMarketplace();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.palette_outlined,
            size: 55,
            color: AppTheme.oliveGreen,
          ),
          SizedBox(height: 16),
          Text(
            'No artwork yet',
            style: TextStyle(
              color: AppTheme.charcoal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Artists will appear here when they publish their artwork.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.softGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// NO SEARCH RESULTS
// ============================================================================

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off,
            size: 50,
            color: AppTheme.oliveGreen,
          ),
          SizedBox(height: 16),
          Text(
            'No artwork found',
            style: TextStyle(
              color: AppTheme.charcoal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try another search or category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.softGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}